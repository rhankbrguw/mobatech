"use client";

import { useState, useRef, useEffect } from "react";
import { useRouter } from "next/navigation";
import { Bell, Siren, Calendar, Pill, CheckCheck, Inbox } from "lucide-react";
import { useNotificationSocket } from "@/hooks/useNotificationSocket";
import { AppNotification } from "@/types/api";

function NotificationIcon({ type }: { type: string }) {
  if (type === "emergency") return <Siren size={16} className="text-error shrink-0" />;
  if (type === "appointment") return <Calendar size={16} className="text-info shrink-0" />;
  if (type === "prescription") return <Pill size={16} className="text-warning shrink-0" />;
  return <Bell size={16} className="text-primary shrink-0" />;
}

export function NotificationBell() {
  const [isOpen, setIsOpen] = useState(false);
  const [filterUnread, setFilterUnread] = useState(false);
  const { notifications, unreadCount, markAsRead, markAllAsRead, hasMore, isLoadingMore, loadMore } = useNotificationSocket();
  const dropdownRef = useRef<HTMLDivElement>(null);
  const router = useRouter();

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const displayedList = filterUnread
    ? notifications.filter((n) => !n.is_read)
    : notifications;

  const handleItemClick = (n: AppNotification) => {
    const id = n.id || (n as { ID?: number }).ID || 0;
    if (!n.is_read && id) markAsRead(id);
    if (n.action_url) {
      setIsOpen(false);
      router.push(n.action_url);
    }
  };

  return (
    <div className="relative" ref={dropdownRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="relative p-2 rounded-xl border border-glass-border bg-background/50 hover:bg-overlay-dark dark:hover:bg-overlay-light transition-colors cursor-pointer text-foreground/70"
        aria-label="Notifikasi"
      >
        <Bell size={18} />
        {unreadCount > 0 && (
          <span className="absolute -top-1 -right-1 min-w-4 h-4 px-1 rounded-full bg-error text-white text-[10px] font-bold flex items-center justify-center animate-pulse">
            {unreadCount > 9 ? "9+" : unreadCount}
          </span>
        )}
      </button>

      {isOpen && (
        <div className="absolute right-0 mt-2 w-80 sm:w-96 rounded-2xl border border-glass-border bg-surface-primary/95 dark:bg-[#0c1f17]/95 backdrop-blur-xl shadow-2xl z-50 overflow-hidden animate-in fade-in slide-in-from-top-2 duration-200">
          <div className="p-3.5 border-b border-glass-border flex items-center justify-between">
            <div className="flex items-center gap-2">
              <span className="font-bold text-sm text-foreground">Notifikasi</span>
              {unreadCount > 0 && (
                <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-primary/20 text-primary">
                  {unreadCount} baru
                </span>
              )}
            </div>
            {unreadCount > 0 && (
              <button
                onClick={markAllAsRead}
                className="text-[11px] text-primary hover:underline flex items-center gap-1 cursor-pointer font-medium"
              >
                <CheckCheck size={14} /> Tandai dibaca
              </button>
            )}
          </div>

          <div className="flex items-center px-3 pt-2 gap-2 border-b border-glass-border/40 pb-2">
            <button
              onClick={() => setFilterUnread(false)}
              className={`text-xs px-2.5 py-1 rounded-lg transition-colors cursor-pointer ${
                !filterUnread ? "bg-primary text-white font-semibold" : "text-foreground/60 hover:text-foreground"
              }`}
            >
              Semua
            </button>
            <button
              onClick={() => setFilterUnread(true)}
              className={`text-xs px-2.5 py-1 rounded-lg transition-colors cursor-pointer ${
                filterUnread ? "bg-primary text-white font-semibold" : "text-foreground/60 hover:text-foreground"
              }`}
            >
              Belum Dibaca
            </button>
          </div>

          <div className="max-h-80 overflow-y-auto divide-y divide-glass-border/40">
            {displayedList.length === 0 ? (
              <div className="p-8 text-center text-foreground/50 text-xs">
                <Inbox size={28} className="mx-auto mb-2 opacity-50" />
                Belum ada notifikasi
              </div>
            ) : (
              displayedList.map((n, idx) => (
                <div
                  key={n.id ?? (n as { ID?: number }).ID ?? idx}
                  onClick={() => handleItemClick(n)}
                  className={`p-3 flex items-start gap-3 hover:bg-overlay-dark dark:hover:bg-overlay-light transition-colors cursor-pointer ${
                    !n.is_read ? "bg-primary/5 dark:bg-primary/10" : ""
                  }`}
                >
                  <NotificationIcon type={n.type} />
                  <div className="flex-1 min-w-0 text-xs">
                    <div className="flex items-center justify-between gap-1">
                      <span className={`font-semibold truncate ${!n.is_read ? "text-primary" : "text-foreground"}`}>
                        {n.title}
                      </span>
                      {!n.is_read && <span className="w-1.5 h-1.5 rounded-full bg-primary shrink-0" />}
                    </div>
                    <p className="text-foreground/70 mt-0.5 line-clamp-2 leading-relaxed">{n.message}</p>
                    <span className="text-[10px] text-foreground/40 mt-1 block">
                      {n.created_at ? new Date(n.created_at).toLocaleTimeString("id-ID", { hour: "2-digit", minute: "2-digit" }) : "Baru saja"}
                    </span>
                  </div>
                </div>
              ))
            )}
            {hasMore && (
              <div className="p-2 text-center border-t border-glass-border/30">
                <button
                  onClick={loadMore}
                  disabled={isLoadingMore}
                  className="text-[11px] text-primary hover:underline font-semibold cursor-pointer disabled:opacity-50"
                >
                  {isLoadingMore ? "Memuat..." : "Muat lebih banyak"}
                </button>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
