import { useState, useEffect } from "react";
import { useQuery } from "@tanstack/react-query";
import { polyclinicService } from "@/services";

export type ToastState = {
  isOpen: boolean;
  message: string;
  type: "success" | "error" | "warning";
};

export function usePolyclinicsData() {
  const [searchQuery, setSearchQuery] = useState("");
  const [filterValue, setFilterValue] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [toast, setToast] = useState<ToastState>({ isOpen: false, message: "", type: "success" });

  useEffect(() => { setCurrentPage(1); }, [searchQuery, filterValue]);

  const queryParams = new URLSearchParams();
  queryParams.append("page", currentPage.toString());
  queryParams.append("limit", "10");
  if (searchQuery) queryParams.append("search", searchQuery);
  if (filterValue) queryParams.append("filter", filterValue);
  const qs = queryParams.toString() ? `?${queryParams.toString()}` : "";

  const { data, isLoading: loading, refetch: loadItems } = useQuery({
    queryKey: ["polyclinics", currentPage, searchQuery, filterValue],
    queryFn: () => polyclinicService.getPolyclinics(qs),
  });

  const items = data?.data || [];
  const totalPages = data?.meta?.total_pages || 1;
  const setItems = () => {}; // Stub for backward compatibility if needed

  return {
    items, setItems, loading, searchQuery, setSearchQuery,
    filterValue, setFilterValue, currentPage, setCurrentPage,
    totalPages, toast, setToast, loadItems
  };
}
