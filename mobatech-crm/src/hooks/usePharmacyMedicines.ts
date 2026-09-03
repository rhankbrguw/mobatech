import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { pharmacyService } from "@/services";
import { Medicine, MedicineCategory } from "@/types/api";
import { APP_STRINGS } from "@/constants";

export function usePharmacyMedicines(
  currentPage: number,
  searchQuery: string,
  selectedCategory: string,
  initialMedicines: Medicine[],
  categories: MedicineCategory[],
  setToast: (toast: { isOpen: boolean; message: string; type: "success" | "error" }) => void,
  setIsModalOpen: (val: boolean) => void,
  setIsCategoryModalOpen: (val: boolean) => void,
  setDeleteConfirm: (val: { isOpen: boolean; id: number; title: string } | null) => void
) {
  const queryClient = useQueryClient();

  const { data: medicinesRes } = useQuery({
    queryKey: ["medicines", currentPage, searchQuery, selectedCategory],
    queryFn: async () => {
      const queryParams = new URLSearchParams();
      queryParams.append("page", currentPage.toString());
      queryParams.append("limit", "10");
      if (searchQuery) queryParams.append("search", searchQuery);
      if (selectedCategory) queryParams.append("category_id", selectedCategory);
      return await pharmacyService.getMedicines(`?${queryParams.toString()}`);
    },
    initialData: (currentPage === 1 && !searchQuery && !selectedCategory) ? ({ data: initialMedicines, meta: { total_pages: 1 } } as unknown as { data: Medicine[]; meta?: { total_pages: number } }) : undefined
  });
  const medicines = medicinesRes?.data || [];
  const totalPages = medicinesRes?.meta?.total_pages || 1;

  const { data: categoriesData } = useQuery({
    queryKey: ["medicineCategories"],
    queryFn: async () => {
      const res = await pharmacyService.getCategories();
      return res.data;
    },
    initialData: categories
  });
  const localCategories = categoriesData || categories;

  const saveMedicineMutation = useMutation({
    mutationFn: (payload: Partial<Medicine>) => {
      if (payload.id) {
        return pharmacyService.updateMedicine(payload.id, payload);
      }
      return pharmacyService.createMedicine(payload);
    },
    onSuccess: (_, variables) => {
      setToast({ isOpen: true, message: variables.id ? APP_STRINGS.common.updateSuccess : APP_STRINGS.common.createSuccess, type: "success" });
      setIsModalOpen(false);
      queryClient.invalidateQueries({ queryKey: ["medicines"] });
    },
    onError: () => {
      setToast({ isOpen: true, message: APP_STRINGS.common.saveError, type: "error" });
    }
  });

  const saveCategoryMutation = useMutation({
    mutationFn: (payload: { name: string; description: string }) => pharmacyService.createCategory(payload),
    onSuccess: () => {
      setToast({ isOpen: true, message: APP_STRINGS.common.categoryAddSuccess, type: "success" });
      setIsCategoryModalOpen(false);
      queryClient.invalidateQueries({ queryKey: ["medicineCategories"] });
    },
    onError: () => {
      setToast({ isOpen: true, message: APP_STRINGS.common.categoryAddError, type: "error" });
    }
  });

  const deleteMedicineMutation = useMutation({
    mutationFn: (id: number) => pharmacyService.deleteMedicine(id),
    onSuccess: () => {
      setToast({ isOpen: true, message: APP_STRINGS.common.deleteSuccess, type: "success" });
      queryClient.invalidateQueries({ queryKey: ["medicines"] });
      setDeleteConfirm(null);
    },
    onError: () => {
      setToast({ isOpen: true, message: APP_STRINGS.common.deleteError, type: "error" });
      setDeleteConfirm(null);
    }
  });

  return {
    medicines,
    totalPages,
    localCategories,
    saveMedicineMutation,
    saveCategoryMutation,
    deleteMedicineMutation
  };
}
