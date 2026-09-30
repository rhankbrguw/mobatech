"use client";

import { PharmacyPrescriptions } from "@/components/pharmacy/PharmacyPrescriptions";
import { Prescription } from "@/types/api";

export default function PrescriptionsPage({ initialPrescriptions }: { initialPrescriptions: Prescription[] }) {
  return (
    <div className="space-y-6 animate-slide-in">
      <PharmacyPrescriptions initialPrescriptions={initialPrescriptions} />
    </div>
  );
}
