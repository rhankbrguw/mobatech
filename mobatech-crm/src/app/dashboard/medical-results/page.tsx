import { MedicalResultsClient } from "@/components/MedicalResultsClient";
import { serverFetch } from "@/lib/serverApi";

export const revalidate = 60;


export const metadata = { title: "Hasil Medis | Hermina CRM", description: "Hermina CRM Hasil Medis" };

export default async function Page({ searchParams }: { searchParams: Promise<{ [key: string]: string | string[] | undefined }> }) {
  const page = (await searchParams).page || "1";
  const search = (await searchParams).search || "";
  
  let initialData: unknown = [];
  let medicines: unknown = [];
  try {
    const [resData, resMed] = await Promise.allSettled([
      serverFetch(`/api/admin/medical-results?page=${page}&search=${search}`),
      serverFetch(`/api/pharmacy/medicines?limit=100`)
    ]);
    if (resData.status === "fulfilled") initialData = resData.value;
    if (resMed.status === "fulfilled") medicines = resMed.value;
  } catch (e) {
    console.error(e);
  }

  return <><h1 className="sr-only">{metadata.title as string}</h1><MedicalResultsClient initialData={initialData} initialMedicines={medicines} searchParams={await searchParams} /></>;
}
