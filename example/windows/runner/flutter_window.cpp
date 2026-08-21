#include "flutter_window.h"

#include <optional>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <flutter/encodable_value.h>

#include "flutter/generated_plugin_registrant.h"

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  // Register window management MethodChannel
  auto window_channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          flutter_controller_->engine()->messenger(), "kallopis/window",
          &flutter::StandardMethodCodec::GetInstance());

  HWND const hwnd = GetHandle();
  window_channel->SetMethodCallHandler(
      [this, hwnd](const flutter::MethodCall<flutter::EncodableValue>& call,
             std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        if (call.method_name() == "minimize") {
          ShowWindow(hwnd, SW_MINIMIZE);
          result->Success();
        } else if (call.method_name() == "maximize") {
          if (IsZoomed(hwnd)) {
            ShowWindow(hwnd, SW_RESTORE);
          } else {
            ShowWindow(hwnd, SW_MAXIMIZE);
          }
          result->Success();
        } else if (call.method_name() == "drag") {
          ReleaseCapture();
          SendMessage(hwnd, WM_NCLBUTTONDOWN, HTCAPTION, 0);
          result->Success();
        } else if (call.method_name() == "setMinSize") {
          const auto* args = std::get_if<flutter::EncodableMap>(call.arguments());
          if (args) {
            int width = 0;
            int height = 0;
            auto w_it = args->find(flutter::EncodableValue("width"));
            if (w_it != args->end() && !w_it->second.IsNull()) {
              if (std::holds_alternative<int32_t>(w_it->second)) {
                width = std::get<int32_t>(w_it->second);
              } else if (std::holds_alternative<int64_t>(w_it->second)) {
                width = static_cast<int>(std::get<int64_t>(w_it->second));
              } else if (std::holds_alternative<double>(w_it->second)) {
                width = static_cast<int>(std::get<double>(w_it->second));
              }
            }
            auto h_it = args->find(flutter::EncodableValue("height"));
            if (h_it != args->end() && !h_it->second.IsNull()) {
              if (std::holds_alternative<int32_t>(h_it->second)) {
                height = std::get<int32_t>(h_it->second);
              } else if (std::holds_alternative<int64_t>(h_it->second)) {
                height = static_cast<int>(std::get<int64_t>(h_it->second));
              } else if (std::holds_alternative<double>(h_it->second)) {
                height = static_cast<int>(std::get<double>(h_it->second));
              }
            }
            this->SetMinSize(width, height);
          }
          result->Success();
        } else if (call.method_name() == "close") {
          PostMessage(hwnd, WM_CLOSE, 0, 0);
          result->Success();
        } else if (call.method_name() == "isMaximized") {
          result->Success(flutter::EncodableValue(IsZoomed(hwnd) != 0));
        } else {
          result->NotImplemented();
        }
      });

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  if (message == WM_NCHITTEST) {
    if (IsZoomed(hwnd)) {
      // When maximized, force HTCLIENT so the invisible WS_THICKFRAME border
      // does not swallow clicks intended for the Flutter toolbar area.
      return HTCLIENT;
    }
    POINT pt = {static_cast<SHORT>(LOWORD(lparam)),
                static_cast<SHORT>(HIWORD(lparam))};
    RECT rect;
    GetWindowRect(hwnd, &rect);
    const int border = 8;

    bool left = pt.x >= rect.left && pt.x < rect.left + border;
    bool right = pt.x < rect.right && pt.x >= rect.right - border;
    bool top = pt.y >= rect.top && pt.y < rect.top + border;
    bool bottom = pt.y < rect.bottom && pt.y >= rect.bottom - border;

    if (top && left) return HTTOPLEFT;
    if (top && right) return HTTOPRIGHT;
    if (bottom && left) return HTBOTTOMLEFT;
    if (bottom && right) return HTBOTTOMRIGHT;
    if (left) return HTLEFT;
    if (right) return HTRIGHT;
    if (top) return HTTOP;
    if (bottom) return HTBOTTOM;
  }

  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
