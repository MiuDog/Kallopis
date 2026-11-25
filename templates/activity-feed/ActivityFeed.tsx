import type { ReactNode } from 'react';
import { KlpFrame } from '@kallopis/react';
import './activity-feed.css';

export interface ActivityFeedProps {
	/* toolbar為consumer操作，children為已投影項目；empty/notice均由consumer決定顯示時機，不在模板判斷產品狀態。 */
	toolbar?: ReactNode;
	children: ReactNode;
	empty?: ReactNode;
	notice?: ReactNode;
}
export interface ActivityFeedItemProps {
	/* heading/description/metadata/actions只承接呈現插槽，無資料識別、排序、路由、已讀或保存語意。 */
	heading: ReactNode;
	description?: ReactNode;
	metadata?: ReactNode;
	actions?: ReactNode;
}

export function ActivityFeed({ toolbar, children, empty, notice }: ActivityFeedProps) {
	return <div className="klp-activity-feed">{toolbar && <div className="klp-activity-toolbar">{toolbar}</div>}{children}{empty}{notice}</div>;
}

export function ActivityFeedItem({ heading, description, metadata, actions }: ActivityFeedItemProps) {
	return <KlpFrame surface="flat" className="klp-activity-item"><div className="klp-activity-content">{heading}{description}{metadata}{actions && <div className="klp-activity-actions">{actions}</div>}</div></KlpFrame>;
}
