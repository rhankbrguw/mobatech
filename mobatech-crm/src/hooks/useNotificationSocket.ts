"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import { AppNotification } from "@/types/api";
import { notificationService } from "@/services";
import { useAuthStore } from "@/store/useAuthStore";

function getAuthToken(): string | null {
  const storeToken = useAuthStore.getState().token;
  if (storeToken) return storeToken;
  if (typeof window !== "undefined") {
    try {
      const stored = localStorage.getItem("hermina-crm-auth");
      if (stored) {
        const parsed = JSON.parse(stored);
        return parsed?.state?.token || null;
      }
    } catch {
      // Ignore
    }
  }
  return null;
}

export function useNotificationSocket() {
  const authToken = useAuthStore((state) => state.token);
  const [notifications, setNotifications] = useState<AppNotification[]>([]);
  const [unreadCount, setUnreadCount] = useState<number>(0);
  const [total, setTotal] = useState<number>(0);
  const [page, setPage] = useState<number>(1);
  const [isLoadingMore, setIsLoadingMore] = useState<boolean>(false);
  const [isConnected, setIsConnected] = useState<boolean>(false);
  const wsRef = useRef<WebSocket | null>(null);
  const reconnectTimeoutRef = useRef<NodeJS.Timeout | null>(null);

  const fetchNotifications = useCallback(async () => {
    try {
      const res = await notificationService.getNotifications(false, 1, 20);
      if (res.data) {
        setNotifications(res.data.notifications || []);
        setUnreadCount(res.data.unread_count || 0);
        setTotal(res.data.total || 0);
        setPage(1);
      }
    } catch {
      // Silently ignore initial fetch error
    }
  }, []);

  const loadMore = useCallback(async () => {
    if (isLoadingMore || notifications.length >= total) return;
    setIsLoadingMore(true);
    try {
      const nextPage = page + 1;
      const res = await notificationService.getNotifications(false, nextPage, 20);
      if (res.data?.notifications) {
        setNotifications((prev) => [...prev, ...res.data.notifications]);
        setPage(nextPage);
        setTotal(res.data.total);
      }
    } finally {
      setIsLoadingMore(false);
    }
  }, [isLoadingMore, notifications.length, total, page]);

  const handleMessage = useCallback((event: MessageEvent) => {
    try {
      const newNotif: AppNotification = JSON.parse(event.data);
      setNotifications((prev) => [newNotif, ...prev.filter((n) => n.id !== newNotif.id)]);
      setUnreadCount((c) => c + 1);
    } catch {
      // Ignore unparseable frames
    }
  }, []);

  const connectWSRef = useRef<((token: string) => void) | null>(null);

  const connectWS = useCallback((activeToken: string) => {
    if (!activeToken) return;
    const base = process.env.NEXT_PUBLIC_API_URL || "http://127.0.0.1:8080";
    const wsUrl = `${base.replace(/^http/, "ws")}/api/ws/notifications?token=${activeToken}`;

    try {
      const ws = new WebSocket(wsUrl);
      wsRef.current = ws;

      ws.onopen = () => setIsConnected(true);
      ws.onmessage = handleMessage;
      ws.onclose = () => {
        setIsConnected(false);
        reconnectTimeoutRef.current = setTimeout(() => connectWSRef.current?.(activeToken), 5000);
      };
      ws.onerror = () => ws.close();
    } catch {
      reconnectTimeoutRef.current = setTimeout(() => connectWSRef.current?.(activeToken), 5000);
    }
  }, [handleMessage]);

  useEffect(() => {
    connectWSRef.current = connectWS;
  }, [connectWS]);

  useEffect(() => {
    const token = authToken || getAuthToken();
    if (!token) return;
    fetchNotifications();
    connectWS(token);
    return () => {
      if (reconnectTimeoutRef.current) clearTimeout(reconnectTimeoutRef.current);
      if (wsRef.current) wsRef.current.close();
    };
  }, [authToken, fetchNotifications, connectWS]);

  const markAsRead = async (id: number) => {
    try {
      await notificationService.markAsRead(id);
      setNotifications((prev) =>
        prev.map((n) => (n.id === id || n.ID === id ? { ...n, is_read: true } : n))
      );
      setUnreadCount((c) => Math.max(0, c - 1));
    } catch {
      // Ignore error
    }
  };

  const markAllAsRead = async () => {
    try {
      await notificationService.markAllAsRead();
      setNotifications((prev) => prev.map((n) => ({ ...n, is_read: true })));
      setUnreadCount(0);
    } catch {
      // Ignore error
    }
  };

  const hasMore = notifications.length < total;
  return { notifications, unreadCount, total, hasMore, isLoadingMore, loadMore, isConnected, markAsRead, markAllAsRead, refresh: fetchNotifications };
}
