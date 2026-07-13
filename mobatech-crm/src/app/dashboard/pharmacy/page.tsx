import { serverFetch } from "@/lib/serverApi";
import { PharmacyClient } from "@/components/pharmacy/PharmacyClient";
import { PharmacyOrder, Medicine, MedicineCategory, Prescription } from "@/types/api";

export const revalidate = 60;


export const metadata = { title: "Manajemen Farmasi | Hermina CRM", description: "Hermina CRM Manajemen Farmasi" };

export default async function PharmacyPage({ searchParams }: { searchParams: Promise<{ [key: string]: string | string[] | undefined }> }) {
  const tab = typeof (await searchParams).tab === "string" ? (await searchParams).tab : "orders";
  const page = typeof (await searchParams).page === "string" ? (await searchParams).page : "1";
  const search = typeof (await searchParams).search === "string" ? (await searchParams).search : "";

  let orders: PharmacyOrder[] = [];
  let medicines: Medicine[] = [];
  let categories: MedicineCategory[] = [];

  try {
    const [ordersRes, medicinesRes, categoriesRes] = await Promise.allSettled([
      serverFetch(`/api/admin/pharmacy/orders?page=${page}&search=${search}`),
      serverFetch(`/api/pharmacy/medicines?limit=100&page=${page}&search=${search}`),
      serverFetch(`/api/pharmacy/categories`),
    ]);
    
    if (ordersRes.status === "fulfilled") orders = ordersRes.value as PharmacyOrder[];
    if (medicinesRes.status === "fulfilled") medicines = medicinesRes.value as Medicine[];
    if (categoriesRes.status === "fulfilled") categories = categoriesRes.value as MedicineCategory[];
  } catch (e) {
    /* ignored */
  }

  return <><h1 className="sr-only">{metadata.title as string}</h1><PharmacyClient initialMedicines={medicines} categories={categories} initialOrders={orders} /></>;
}
