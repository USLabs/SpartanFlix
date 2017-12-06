CREATE UNIQUE INDEX by_a_advertiser_id ON Advertiser (id);
CREATE UNIQUE INDEX by_a_email ON Advertiser (email);

CREATE UNIQUE INDEX by_a_id ON Advertisement(id);

CREATE UNIQUE INDEX by_v_id ON Viewer (id);
CREATE INDEX by_v_mainSubscriberId ON Viewer (mainSubscriberId);
CREATE UNIQUE INDEX by_v_email ON Viewer (email);

CREATE INDEX by_w_contentId ON Watches (contentId);
CREATE INDEX by_w_viewerId ON Watches (viewerId);
CREATE UNIQUE INDEX by_w_viewerId_contentId ON Watches (viewerId, contentId);

CREATE INDEX by_f_content_id ON Feedback (contentId);
CREATE INDEX by_f_viewerId_contentId ON Feedback (viewerId, contentId);

CREATE UNIQUE INDEX by_c_id ON Content (id);
CREATE INDEX by_c_contentProviderId ON Content (contentProviderId);

CREATE UNIQUE INDEX by_cp_email ON ContentProvider (email);

CREATE UNIQUE INDEX by_content_subscription_id ON ContentSubscription (id);

CREATE INDEX by_i_contentSubscriptionId ON Includes (contentSubscriptionId);

CREATE INDEX by_f_viewerId ON Favorites (viewerId);