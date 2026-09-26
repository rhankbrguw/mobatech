import { useState, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { ApiError } from "@/lib/api";
import { APP_STRINGS } from "@/constants";
import { Promo } from "@/types/api";
import { adminService } from "@/services";

export function usePromosClient() {
  const queryClient = useQueryClient();
  
  const [deleteConfirm, setDeleteConfirm] = useState<{ id: number; title: string } | null>(null);
  const [toast, setToast] = useState<{ isOpen: boolean; message: string; type: "success" | "error" }>({
    isOpen: false, message: "", type: "success"
  });

  const [searchQuery, setSearchQuery] = useState("");
  const [showModal, setShowModal] = useState(false);
  const [editingPromo, setEditingPromo] = useState<Promo | null>(null);
  const [viewingPromo, setViewingPromo] = useState<Promo | null>(null);
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);
  const [currentPage, setCurrentPage] = useState(1);

  useEffect(() => { setCurrentPage(1); }, [searchQuery]);

  const queryParams = new URLSearchParams();
  queryParams.append("page", currentPage.toString());
  queryParams.append("limit", "10");
  if (searchQuery) queryParams.append("search", searchQuery);
  const qs = queryParams.toString() ? `?${queryParams.toString()}` : "";

  const { data: promosRes, isLoading: loading, refetch: loadPromos } = useQuery({
    queryKey: ["promos", currentPage, searchQuery],
    queryFn: () => adminService.getPromos(qs)
  });

  const promos = promosRes?.data || [];
  const totalPages = promosRes?.meta?.total_pages || 1;

  const deleteMutation = useMutation({
    mutationFn: (id: number) => adminService.deletePromo(id),
    onSuccess: () => {
      setToast({ isOpen: true, message: APP_STRINGS.common.deleteSuccess, type: "success" });
      queryClient.invalidateQueries({ queryKey: ["promos"] });
      setDeleteConfirm(null);
    },
    onError: (err: unknown) => {
      setToast({ isOpen: true, message: err instanceof ApiError ? err.message : APP_STRINGS.common.deleteError, type: "error" });
      setDeleteConfirm(null);
    }
  });

  const handleDelete = async () => {
    if (!deleteConfirm) return;
    deleteMutation.mutate(deleteConfirm.id);
  };

  return {
    promos, loading, deleteConfirm, setDeleteConfirm, toast, setToast,
    searchQuery, setSearchQuery, showModal, setShowModal,
    editingPromo, setEditingPromo, viewingPromo, setViewingPromo,
    isDrawerOpen, setIsDrawerOpen, currentPage, setCurrentPage, totalPages,
    loadPromos, handleDelete,
  };
}
