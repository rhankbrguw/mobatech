"use client";
import { useAuthStore } from "@/store/useAuthStore";
import { ForbiddenView } from "@/components/ui/ForbiddenView";
import { PharmacyOrder } from "@/types/api";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { useState } from "react";
import { Badge, BadgeVariant } from "@/components/ui/Badge";
import { api } from "@/lib/api";
import { Card } from "@/components/ui/Card";
import { SearchFilterBar } from "@/components/ui/SearchFilterBar";
import { FilterDropdown } from "@/components/ui/FilterDropdown";
import { Pagination } from "@/components/ui/Pagination";
import { useEffect } from "react";
import { APP_STRINGS } from "@/lib/constants";
import { Formatters } from "@/lib/formatters";
import { StatusPill } from "@/components/StatusPill";
import { PharmacyOrderRow } from "./PharmacyOrderRow";
const TH_CLASS = "align-middle whitespace-nowrap py-3 px-4 text-xs font-bold uppercase tracking-wider text-foreground/50";

export function PharmacyOrders({ initialOrders }: { initialOrders: PharmacyOrder[] }) {
  const role = useAuthStore((state) => state.user)?.role || "admin";
  const [orders, setOrders] = useState<PharmacyOrder[]>(initialOrders);
  const [expandedOrder, setExpandedOrder] = useState<number | null>(null);
  const [searchQuery, setSearchQuery] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [toast, setToast] = useState<{isOpen: boolean; message: string; type: "success"|"error"}>({ isOpen: false, message: "", type: "success" });
  const showToast = (message: string, type: "success" | "error") => setToast({ isOpen: true, message, type });
  const [filterValue, setFilterValue] = useState("");
  
  const loadOrders = async () => {
    try {
      const queryParams = new URLSearchParams();
      queryParams.append("page", currentPage.toString());
      queryParams.append("limit", "10");
      if (searchQuery) queryParams.append("search", searchQuery);
      if (filterValue) queryParams.append("filter", filterValue);
      const qs = queryParams.toString() ? `?${queryParams.toString()}` : "";
      const res = await api.get<PharmacyOrder[]>(`/api/admin/pharmacy/orders${qs}`);
      setOrders(res.data || []);
      if (res.meta) {
        setTotalPages(res.meta.total_pages);
      }
    } catch { /* suppress */ }
  };
  useEffect(() => { setCurrentPage(1); }, [searchQuery, filterValue]);
  useEffect(() => { loadOrders(); }, [searchQuery, filterValue, currentPage]);
  
  const handleUpdateStatus = async (id: number, status: string) => {
    try {
      await api.put(`/api/admin/pharmacy/orders/${id}/status`, { status });
      showToast(APP_STRINGS.common.updateSuccess, "success");
      setOrders(orders.map(o => o.id === id ? { ...o, status } : o));
    } catch { showToast(APP_STRINGS.common.saveError, "error"); }
  };
  
  const handleUpdatePayment = async (id: number, payment_status: string) => {
    try {
      await api.put(`/api/admin/pharmacy/orders/${id}/payment`, { payment_status });
      showToast(APP_STRINGS.common.updateSuccess, "success");
      setOrders(orders.map(o => o.id === id ? { ...o, payment_status } : o));
    } catch { showToast(APP_STRINGS.common.saveError, "error"); }
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
