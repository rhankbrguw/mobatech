import { useState } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { ApiError } from "@/lib/api";
import { APP_STRINGS } from "@/constants";
import { Polyclinic } from "@/types/api";
import { polyclinicService } from "@/services";
import { ToastState } from "./usePolyclinicsData";

interface UsePolyclinicsActionsOptions {
  loadItems: () => Promise<void> | void;
  setToast: React.Dispatch<React.SetStateAction<ToastState>>;
}

export function usePolyclinicsActions({ loadItems, setToast }: UsePolyclinicsActionsOptions) {
  const queryClient = useQueryClient();
  const [showModal, setShowModal] = useState(false);
  const [selectedItem, setSelectedItem] = useState<Polyclinic | null>(null);
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [imageUrl, setImageUrl] = useState("");
  const [isActive, setIsActive] = useState(true);
  const [deleteId, setDeleteId] = useState<number | null>(null);

  const openForm = (item: Polyclinic | null = null) => {
    setSelectedItem(item);
    setName(item ? item.name : "");
    setDescription(item ? item.description : "");
    setImageUrl(item ? item.image_url : "");
    setIsActive(item ? item.is_active : true);
    setShowModal(true);
  };

  const saveMutation = useMutation({
    mutationFn: (payload: Partial<Polyclinic>) => selectedItem ? polyclinicService.updatePolyclinic(selectedItem.id, payload) : polyclinicService.createPolyclinic(payload),
    onSuccess: () => {
      setToast({ isOpen: true, message: selectedItem ? APP_STRINGS.polyclinics.successUpdate : APP_STRINGS.polyclinics.successCreate, type: "success" });
      setShowModal(false);
      queryClient.invalidateQueries({ queryKey: ["polyclinics"] });
      if (loadItems) loadItems();
    },
    onError: (err: unknown) => {
      const msg = err instanceof ApiError ? err.message : APP_STRINGS.login.networkError;
      setToast({ isOpen: true, message: msg, type: "error" });
    }
  });

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    const payload = {
      name, description, is_active: isActive,
      image_url: imageUrl || "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=150",
    };
    saveMutation.mutate(payload);
  };

  const deleteMutation = useMutation({
    mutationFn: (id: number) => polyclinicService.deletePolyclinic(id),
    onSuccess: () => {
      setToast({ isOpen: true, message: APP_STRINGS.polyclinics.successDelete, type: "success" });
      queryClient.invalidateQueries({ queryKey: ["polyclinics"] });
      if (loadItems) loadItems();
      setDeleteId(null);
    },
    onError: (err: unknown) => {
      const msg = err instanceof ApiError ? err.message : APP_STRINGS.login.networkError;
      setToast({ isOpen: true, message: msg, type: "error" });
      setDeleteId(null);
    }
  });

  const handleDelete = async (id: number) => {
    deleteMutation.mutate(id);
  };

  return {
    showModal, setShowModal, selectedItem, name, setName,
    description, setDescription, imageUrl, setImageUrl,
    isActive, setIsActive, saving: saveMutation.isPending || deleteMutation.isPending, deleteId, setDeleteId,
    openForm, handleSave, handleDelete
  };
}
