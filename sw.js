self.addEventListener("push", event => {
  let payload = {};
  try {
    payload = event.data ? event.data.json() : {};
  } catch {
    payload = { title: "Vetamerikan Shift Asistan", body: event.data?.text() || "" };
  }

  const title = payload.title || "Vetamerikan Shift Asistan";
  const options = {
    body: payload.body || "",
    tag: payload.notification_id || "vetamerikan-shift",
    renotify: true,
    data: payload.data || {},
    badge: "vetamerikan-logo.png",
    icon: "vetamerikan-logo.png",
    image: "vetamerikan-logo.png"
  };

  event.waitUntil(self.registration.showNotification(title, options));
});

self.addEventListener("notificationclick", event => {
  event.notification.close();
  const data = event.notification.data || {};
  const targetUrl = new URL(self.registration.scope);

  if (data.push_type === "message") {
    targetUrl.searchParams.set("push_type", "message");
    if (data.doctor_sicil) targetUrl.searchParams.set("doctor_sicil", data.doctor_sicil);
    if (data.peer) targetUrl.searchParams.set("peer", data.peer);
  }

  event.waitUntil((async () => {
    const clientsList = await clients.matchAll({ type: "window", includeUncontrolled: true });
    for (const client of clientsList) {
      if ("focus" in client) {
        await client.focus();
        if (data.push_type === "message") client.postMessage({ type: "push-open", data });
        return;
      }
    }
    await clients.openWindow(targetUrl.href);
  })());
});
