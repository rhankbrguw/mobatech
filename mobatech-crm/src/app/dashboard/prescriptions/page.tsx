import ClientPage from "./Client";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Resep Obat | Hermina CRM",
  description: "Manajemen Resep Obat Hermina CRM"
};

export default function Page() {
  return (
    <>
      <h1 className="sr-only">{metadata.title as string}</h1>
      <ClientPage />
    </>
  );
}
