import { serverFetch } from "@/lib/serverApi";
import ClientPage from "./Client";
import { Metadata } from "next";
import { Prescription } from "@/types/api";

export const metadata: Metadata = {
  title: "Resep Obat | Hermina CRM",
  description: "Manajemen Resep Obat Hermina CRM"
};

export const dynamic = "force-dynamic";

export default async function Page({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>;
}) {
  const params = await searchParams;
  const page = Number(params?.page) || 1;
  const search = (params?.search as string) || "";
  
  let prescriptions: Prescription[] = [];
  try {
    prescriptions = await serverFetch(`/api/admin/pharmacy/prescriptions?page=${page}&search=${search}`);
  } catch (e) {
    /* ignored */
  }

  return (
    <>
      <h1 className="sr-only">{metadata.title as string}</h1>
      <ClientPage initialPrescriptions={prescriptions} />
    </>
  );
}
