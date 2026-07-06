import { useState, useEffect } from "react";
import { useAuthStore } from "@/store/useAuthStore";
import { api, ApiError } from "@/lib/api";
import { APP_STRINGS } from "@/lib/constants";
import { Polyclinic } from "@/types/api";

export function usePolyclinicsLogic() {
  const user = useAuthStore((state) => state.user);
  const role = user?.role || "admin";
  const [items, setItems] = useState<Polyclinic[]>([]);
  const [loading, setLoading] = useState(true);
  const [showModal, setShowModal] = useState(false);
  const [selectedItem, setSelectedItem] = useState<Polyclinic | null>(null);
  const [searchQuery, setSearchQuery] = useState("");
  const [filterValue, setFilterValue] = useState("");
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [imageUrl, setImageUrl] = useState("");
  const [isActive, setIsActive] = useState(true);
  const [saving, setSaving] = useState(false);
  const [drawerItem, setDrawerItem] = useState<Polyclinic | null>(null);
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [toast, setToast] = useState<{
    isOpen: boolean;
    message: string;
    type: "success" | "error" | "warning";
  }>({ isOpen: false, message: "", type: "success" });
  const [deleteId, setDeleteId] = useState<number | null>(null);

  const loadItems = async () => {
    try {
      const queryParams = new URLSearchParams();
      queryParams.append("page", currentPage.toString());
      queryParams.append("limit", "10");
      if (searchQuery) queryParams.append("search", searchQuery);
      if (filterValue) queryParams.append("filter", filterValue);
      const qs = queryParams.toString() ? `?${queryParams.toString()}` : "";
      const res = await api.get<Polyclinic[]>(`/api/polyclinics${qs}`);
      setItems(res.data || []);
      if (res.meta) setTotalPages(res.meta.total_pages);
    } catch {
      setToast({ isOpen: true, message: APP_STRINGS.login.networkError, type: "error" });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { setCurrentPage(1); }, [searchQuery, filterValue]);
  useEffect(() => { loadItems(); }, [searchQuery, filterValue, currentPage]);

  const openForm = (item: Polyclinic | null = null) => {
    setSelectedItem(item);
    setName(item ? item.name : "");
    setDescription(item ? item.description : "");
    setImageUrl(item ? item.image_url : "");
    setIsActive(item ? item.is_active : true);
    setShowModal(true);
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    const payload = {
      name, description, is_active: isActive,
      image_url: imageUrl || "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=150",
    };
    try {
      if (selectedItem) {
        await api.put(`/api/admin/polyclinics/${selectedItem.id}`, payload);
        setToast({ isOpen: true, message: APP_STRINGS.polyclinics.successUpdate, type: "success" });
      } else {
        await api.post("/api/admin/polyclinics", payload);
        setToast({ isOpen: true, message: APP_STRINGS.polyclinics.successCreate, type: "success" });
      }
      setShowModal(false);
      loadItems();
    } catch (err) {
      const msg = err instanceof ApiError ? err.message : APP_STRINGS.login.networkError;
      setToast({ isOpen: true, message: msg, type: "error" });
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (id: number) => {
    setSaving(true);
    try {
      await api.delete(`/api/admin/polyclinics/${id}`);
      setToast({ isOpen: true, message: APP_STRINGS.polyclinics.successDelete, type: "success" });
      loadItems();
    } catch (err) {
      const msg = err instanceof ApiError ? err.message : APP_STRINGS.login.networkError;
      setToast({ isOpen: true, message: msg, type: "error" });
    } finally {
      setSaving(false);
      setDeleteId(null);
    }
  };

  return {
    role, items, loading, showModal, setShowModal, selectedItem,
    searchQuery, setSearchQuery, filterValue, setFilterValue,
    name, setName, description, setDescription, imageUrl, setImageUrl,
    isActive, setIsActive, saving, drawerItem, setDrawerItem,
    isDrawerOpen, setIsDrawerOpen, currentPage, setCurrentPage,
    totalPages, toast, setToast, deleteId, setDeleteId,
    openForm, handleSave, handleDelete
  };
}
