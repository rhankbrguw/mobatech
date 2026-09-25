import { useState, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { ApiError } from "@/lib/api";
import { User } from "@/types/api";
import { useAuthStore } from "@/store/useAuthStore";
import { APP_STRINGS } from "@/constants";
import { adminService } from "@/services";

export function useUsersClient() {
  const queryClient = useQueryClient();
  const authUser = useAuthStore((state) => state.user);
  const role = authUser?.role || "admin";

  const [showModal, setShowModal] = useState(false);
  const [editingUser, setEditingUser] = useState<Partial<User> | null>(null);
  const [viewingUser, setViewingUser] = useState<User | null>(null);
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);
  const [deleteConfirm, setDeleteConfirm] = useState<{ id: number; title: string } | null>(null);
  const [searchQuery, setSearchQuery] = useState("");
  const [roleFilter, setRoleFilter] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [toast, setToast] = useState<{ isOpen: boolean; message: string; type: "success" | "error" }>({
    isOpen: false, message: "", type: "success"
  });

  useEffect(() => { setCurrentPage(1); }, [searchQuery, roleFilter]);

  const queryParams = new URLSearchParams();
  queryParams.append("page", currentPage.toString());
  queryParams.append("limit", "10");
  if (searchQuery) queryParams.append("search", searchQuery);
  if (roleFilter) queryParams.append("role", roleFilter);
  const qs = queryParams.toString() ? `?${queryParams.toString()}` : "";

  const { data: usersData, isLoading: loading, refetch: loadUsers } = useQuery({
    queryKey: ["users", currentPage, searchQuery, roleFilter],
    queryFn: () => adminService.getUsers(qs)
  });

  const users = usersData?.data || [];
  const totalPages = usersData?.meta?.total_pages || 1;

  const deleteMutation = useMutation({
    mutationFn: (id: number) => adminService.deleteUser(id),
    onSuccess: () => {
      setToast({ isOpen: true, message: APP_STRINGS.common.userDeleteSuccess, type: "success" });
      queryClient.invalidateQueries({ queryKey: ["users"] });
      setDeleteConfirm(null);
    },
    onError: (err: unknown) => {
      setToast({ isOpen: true, message: err instanceof ApiError ? err.message : "Gagal menghapus", type: "error" });
      setDeleteConfirm(null);
    }
  });

  const handleDelete = async () => {
    if (!deleteConfirm) return;
    deleteMutation.mutate(deleteConfirm.id);
  };

  return {
    authUser, role, users, loading, showModal, setShowModal,
    editingUser, setEditingUser, viewingUser, setViewingUser,
    isDrawerOpen, setIsDrawerOpen, deleteConfirm, setDeleteConfirm,
    searchQuery, setSearchQuery, roleFilter, setRoleFilter,
    currentPage, setCurrentPage, totalPages, toast, setToast,
    loadUsers, handleDelete,
  };
}
