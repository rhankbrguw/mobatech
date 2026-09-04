import { PharmacyOrder } from "@/types/api";
import { Formatters } from "@/lib/formatters";
import { StatusPill } from "@/components/StatusPill";
import { ChevronDown, ChevronUp } from "lucide-react";

interface PharmacyOrderRowProps {
  order: PharmacyOrder;
  role: string;
  isExpanded: boolean;
  onToggle: () => void;
  onUpdateStatus: (id: number, status: string) => void;
  onUpdatePayment: (id: number, status: string) => void;
}

const TD_CLASS = "align-middle whitespace-nowrap py-4 px-4 border-b border-glass-border/50";
const ORDER_STATUSES = ["Pending", "Processing", "Ready", "Completed", "Cancelled"];
const PAYMENT_STATUSES = ["Unpaid", "Paid", "Refunded"];

export function PharmacyOrderRow({ order, role, isExpanded, onToggle, onUpdateStatus, onUpdatePayment }: PharmacyOrderRowProps) {
  return (
    <>
      <tr className="hover:bg-overlay-dark] dark:hover:bg-overlay-light] transition-colors group cursor-pointer" onClick={onToggle}>
        <td className={`${TD_CLASS} text-center font-bold text-foreground`}>
          {order.order_number}
        </td>
        <td className={`${TD_CLASS} text-center text-foreground/70 text-xs`}>
          <div>{Formatters.date(order.created_at, "datetime")}</div>
          <div className="font-semibold text-primary">{order.pickup_method}</div>
        </td>
        <td className={`${TD_CLASS} text-center`}>
          <StatusPill status={order.status} />
        </td>
        <td className={`${TD_CLASS} text-center`}>
          <StatusPill status={order.payment_status} />
        </td>
        <td className={`${TD_CLASS} text-center font-bold text-foreground`}>
          {Formatters.currency(order.total_price)}
        </td>
        <td className={`${TD_CLASS} text-center`}>
          <button className="p-2 bg-overlay-dark dark:bg-overlay-light rounded-full hover:bg-overlay-dark dark:hover:bg-overlay-light transition-colors">
            {isExpanded ? <ChevronUp size={16} /> : <ChevronDown size={16} />}
          </button>
        </td>
      </tr>

      {isExpanded && (
        <tr className="bg-overlay-dark] dark:bg-overlay-light]">
          <td colSpan={6} className="p-0 border-b border-glass-border/50">
            <div className="p-4 space-y-3 animate-slide-in">
              <div className="text-xs text-foreground/50 font-semibold uppercase tracking-wider">Item Pesanan</div>
              {order.items?.map((item) => (
                <div key={item.id} className="flex justify-between text-sm">
                  <span>{item.medicine?.name ?? `Obat #${item.medicine_id}`} × {item.quantity}</span>
                  <span className="font-medium">{Formatters.currency(item.subtotal)}</span>
                </div>
              ))}
              {order.delivery_address && <div className="text-xs text-foreground/60 mt-2"><span className="font-medium">Alamat:</span> {order.delivery_address}</div>}
              {order.notes && <div className="text-xs text-foreground/60"><span className="font-medium">Catatan:</span> {order.notes}</div>}
              
              <div className="flex gap-4 pt-3 mt-3 border-t border-glass-border flex-wrap">
                <div className="flex flex-col gap-1.5" title={role === "admin" ? "Aksi klinis hanya untuk Dokter/Apoteker" : undefined}>
                  <span className="text-xs font-semibold text-foreground/70">Status Order</span>
                  <select value={order.status} onChange={(e) => onUpdateStatus(order.id, e.target.value)} disabled={role === "admin"}
                    className="text-sm border border-glass-border rounded-xl px-3 py-1.5 bg-background glass-input cursor-pointer outline-none focus:border-primary disabled:opacity-50 transition-all">
                    {ORDER_STATUSES.map((s) => <option key={s}>{s}</option>)}
                  </select>
                </div>
                <div className="flex flex-col gap-1.5" title={role === "admin" ? "Aksi klinis hanya untuk Dokter/Apoteker" : undefined}>
                  <span className="text-xs font-semibold text-foreground/70">Status Pembayaran</span>
                  <select value={order.payment_status} onChange={(e) => onUpdatePayment(order.id, e.target.value)} disabled={role === "admin"}
                    className="text-sm border border-glass-border rounded-xl px-3 py-1.5 bg-background glass-input cursor-pointer outline-none focus:border-primary disabled:opacity-50 transition-all">
                    {PAYMENT_STATUSES.map((s) => <option key={s}>{s}</option>)}
                  </select>
                </div>
              </div>
            </div>
          </td>
        </tr>
      )}
    </>
  );
}
