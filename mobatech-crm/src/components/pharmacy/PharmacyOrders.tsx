"use client";
import { useAuthStore } from "@/store/useAuthStore";
import { PharmacyOrder } from "@/types/api";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { useState, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { pharmacyService } from "@/services";
import { Card } from "@/components/ui/Card";
import { SearchFilterBar } from "@/components/ui/SearchFilterBar";
import { FilterDropdown } from "@/components/ui/FilterDropdown";
import { Pagination } from "@/components/ui/Pagination";
import { APP_STRINGS } from "@/constants";
import { PharmacyOrderRow } from "./PharmacyOrderRow";
const TH_CLASS = "align-middle whitespace-nowrap py-3 px-4 text-xs font-bold uppercase tracking-wider text-foreground/50";

export function PharmacyOrders({ initialOrders }: { initialOrders: PharmacyOrder[] }) {
  const role = useAuthStore((state) => state.user)?.role || "admin";
  const queryClient = useQueryClient();
  const [expandedOrder, setExpandedOrder] = useState<number | null>(null);
  const [searchQuery, setSearchQuery] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [toast, setToast] = useState<{isOpen: boolean; message: string; type: "success"|"error"}>({ isOpen: false, message: "", type: "success" });
  const showToast = (message: string, type: "success" | "error") => setToast({ isOpen: true, message, type });
  const [filterValue, setFilterValue] = useState("");
  
  const { data: ordersRes } = useQuery({
    queryKey: ["pharmacyOrders", currentPage, searchQuery, filterValue],
    queryFn: async () => {
      const queryParams = new URLSearchParams();
      queryParams.append("page", currentPage.toString());
      queryParams.append("limit", "10");
      if (searchQuery) queryParams.append("search", searchQuery);
      if (filterValue) queryParams.append("filter", filterValue);
      const qs = queryParams.toString() ? `?${queryParams.toString()}` : "";
      return await pharmacyService.getOrders(qs);
    },
    initialData: (currentPage === 1 && !searchQuery && !filterValue) ? ({ data: initialOrders, meta: { total_pages: 1 } } as unknown as { data: PharmacyOrder[]; meta?: { total_pages: number } }) : undefined
  });

  const orders = ordersRes?.data || [];
  const totalPages = ordersRes?.meta?.total_pages || 1;

  useEffect(() => { setCurrentPage(1); }, [searchQuery, filterValue]);
  
  const updateStatusMutation = useMutation({
    mutationFn: (args: {id: number, status: string}) => pharmacyService.updateOrderStatus(args.id, { status: args.status }),
    onSuccess: () => {
      showToast(APP_STRINGS.common.updateSuccess, "success");
      queryClient.invalidateQueries({ queryKey: ["pharmacyOrders"] });
    },
    onError: () => {
      showToast(APP_STRINGS.common.saveError, "error");
    }
  });

  const handleUpdateStatus = async (id: number, status: string) => {
    updateStatusMutation.mutate({ id, status });
  };
  
  const updatePaymentMutation = useMutation({
    mutationFn: (args: {id: number, payment_status: string}) => pharmacyService.updateOrderPayment(args.id, { payment_status: args.payment_status }),
    onSuccess: () => {
      showToast(APP_STRINGS.common.updateSuccess, "success");
      queryClient.invalidateQueries({ queryKey: ["pharmacyOrders"] });
    },
    onError: () => {
      showToast(APP_STRINGS.common.saveError, "error");
    }
  });

  const handleUpdatePayment = async (id: number, payment_status: string) => {
    updatePaymentMutation.mutate({ id, payment_status });
  };

  return (
    <div className="space-y-4">
      <div className="flex flex-col sm:flex-row items-stretch sm:items-center justify-end gap-2">
        <div className="flex flex-col sm:flex-row flex-1 sm:flex-none gap-2">
          <FilterDropdown
            value={filterValue}
            onChange={setFilterValue}
            options={[
              { label: 'Semua Status', value: '' },
              { label: 'Pending', value: 'Pending' },
              { label: 'Diproses', value: 'Processing' },
              { label: 'Siap', value: 'Ready' },
              { label: 'Selesai', value: 'Completed' },
              { label: 'Dibatalkan', value: 'Cancelled' },
            ]}
            placeholder={APP_STRINGS.common.searchStatus}
            className="w-full sm:w-64 h-11"
          />
          <SearchFilterBar value={searchQuery} onChange={setSearchQuery} className="w-full sm:max-w-sm h-11" />
        </div>
      </div>
      
      <Card noPadding>
        {orders.length === 0 ? (
          <div className="p-10 text-center text-foreground/50 text-sm">Belum ada order masuk.</div>
        ) : (
          <div className="w-full overflow-x-auto">
            <table className="w-full border-collapse text-sm">
              <thead>
                <tr className="border-b border-glass-border bg-overlay-dark] dark:bg-overlay-light]">
                  <th className={`${TH_CLASS} text-center`}>No. Pesanan</th>
                  <th className={`${TH_CLASS} text-center`}>Informasi Pemesan</th>
                  <th className={`${TH_CLASS} text-center`}>Status</th>
                  <th className={`${TH_CLASS} text-center`}>Pembayaran</th>
                  <th className={`${TH_CLASS} text-center`}>Total</th>
                  <th className={`${TH_CLASS} text-center w-16`}>Detail</th>
                </tr>
              </thead>
              <tbody>
                {orders.map((order) => (
                  <PharmacyOrderRow
                    key={order.order_number || order.id}
                    order={order}
                    role={role}
                    isExpanded={expandedOrder === order.id}
                    onToggle={() => setExpandedOrder(expandedOrder === order.id ? null : order.id)}
                    onUpdateStatus={handleUpdateStatus}
                    onUpdatePayment={handleUpdatePayment}
                  />
                ))}
              </tbody>
            </table>
          </div>
        )}
      </Card>
      <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={setCurrentPage} />
      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast((t) => ({ ...t, isOpen: false }))} />
    </div>
  );
}
