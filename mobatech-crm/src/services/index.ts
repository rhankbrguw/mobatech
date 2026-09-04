import { api } from "@/lib/api";
import { 
  Polyclinic, Doctor, DoctorSchedule, PharmacyOrder, Prescription, 
  Medicine, MedicineCategory, ChatSession, RagStatus, User, Reminder, 
  Branch, Appointment, MedicalResult, EmergencyRequest, Promo, LoginResponseData
} from "@/types/api";

export const authService = {
  login: (data: Record<string, unknown>) => api.post<LoginResponseData>("/api/auth/login", data),
};

export const polyclinicService = {
  getPolyclinics: (qs: string = "") => api.get<Polyclinic[]>(`/api/polyclinics${qs}`),
  createPolyclinic: (payload: Partial<Polyclinic>) => api.post("/api/admin/polyclinics", payload),
  updatePolyclinic: (id: number | string, payload: Partial<Polyclinic>) => api.put(`/api/admin/polyclinics/${id}`, payload),
  deletePolyclinic: (id: number | string) => api.delete(`/api/admin/polyclinics/${id}`),
};

export const doctorService = {
  getDoctors: (qs: string = "") => api.get<Doctor[]>(`/api/doctors${qs}`),
  getDoctorSchedules: (doctorId: string) => api.get<DoctorSchedule[]>(`/api/doctors/${doctorId}/schedules`),
  getAllSchedules: (qs: string = "") => api.get<DoctorSchedule[]>(`/api/admin/schedules${qs}`),
  createDoctor: (payload: Partial<Doctor>) => api.post("/api/admin/doctors", payload),
  updateDoctor: (id: number | string, payload: Partial<Doctor>) => api.put(`/api/admin/doctors/${id}`, payload),
  deleteDoctor: (id: number | string) => api.delete(`/api/admin/doctors/${id}`),
  createDoctorSchedule: (payload: Partial<DoctorSchedule>) => api.post("/api/admin/schedules", payload),
  deleteDoctorSchedule: (id: number | string) => api.delete(`/api/admin/schedules/${id}`),
};

export const pharmacyService = {
  getMedicines: (qs: string = "") => api.get<Medicine[]>(`/api/pharmacy/medicines${qs}`),
  getCategories: () => api.get<MedicineCategory[]>("/api/pharmacy/categories"),
  getOrders: (qs: string = "") => api.get<PharmacyOrder[]>(`/api/admin/pharmacy/orders${qs}`),
  getPrescriptions: (qs: string = "") => api.get<Prescription[]>(`/api/admin/pharmacy/prescriptions${qs}`),
  createPrescription: (data: Partial<Prescription>) => api.post("/api/admin/pharmacy/prescriptions", data),
  updatePrescriptionStatus: (id: number, data: { status: string; notes?: string }) => api.put(`/api/admin/pharmacy/prescriptions/${id}/status`, data),
  createMedicine: (data: Partial<Medicine>) => api.post("/api/admin/pharmacy/medicines", data),
  updateMedicine: (id: number, data: Partial<Medicine>) => api.put(`/api/admin/pharmacy/medicines/${id}`, data),
  deleteMedicine: (id: number) => api.delete(`/api/admin/pharmacy/medicines/${id}`),
  createCategory: (data: { name: string; description: string }) => api.post("/api/admin/pharmacy/categories", data),
  updateOrderStatus: (id: number, data: { status: string }) => api.put(`/api/admin/pharmacy/orders/${id}/status`, data),
  updateOrderPayment: (id: number, data: { payment_status: string }) => api.put(`/api/admin/pharmacy/orders/${id}/payment`, data),
};

export const adminService = {
  getUsers: (qs: string = "") => api.get<User[]>(`/api/admin/users${qs}`),
  createUser: (payload: Partial<User>) => api.post("/api/admin/users", payload),
  updateUser: (id: number | string, payload: Partial<User>) => api.put(`/api/admin/users/${id}`, payload),
  deleteUser: (id: number | string) => api.delete(`/api/admin/users/${id}`),
  getPatients: () => api.get<User[]>("/api/admin/users?role=patient"),
  
  getAppointments: (qs: string = "") => api.get<Appointment[]>(`/api/admin/appointments${qs}`),
  actionAppointment: (id: number | string, action: string) => api.post(`/api/admin/appointments/${id}/${action}`, {}),
  
  getEmergenciesList: (qs: string = "") => api.get<EmergencyRequest[]>(`/api/admin/emergencies${qs}`),
  updateEmergencyStatus: (id: number | string, status: string) => api.put(`/api/admin/emergencies/${id}/status`, { status }),
  
  getReminders: (qs: string = "") => api.get<Reminder[]>(`/api/admin/reminders${qs}`),
  createReminder: (payload: Partial<Reminder>) => api.post("/api/admin/reminders", payload),
  deleteReminder: (id: number | string) => api.delete(`/api/admin/reminders/${id}`),
  
  getBranches: (qs: string = "") => api.get<Branch[]>(`/api/branches${qs}`),
  createBranch: (payload: Partial<Branch>) => api.post("/api/admin/branches", payload),
  updateBranch: (id: number | string, payload: Partial<Branch>) => api.put(`/api/admin/branches/${id}`, payload),
  deleteBranch: (id: number | string) => api.delete(`/api/admin/branches/${id}`),
  
  getMedicalResults: (qs: string = "") => api.get<MedicalResult[]>(`/api/admin/medical-results${qs}`),
  createMedicalResult: (payload: Partial<MedicalResult>) => api.post("/api/admin/medical-results", payload),
  updateMedicalResult: (id: number | string, payload: Partial<MedicalResult>) => api.put(`/api/admin/medical-results/${id}`, payload),
  deleteMedicalResult: (id: number | string) => api.delete(`/api/admin/medical-results/${id}`),
  
  getPromos: (qs: string = "") => api.get<Promo[]>(`/api/admin/promos${qs}`),
  createPromo: (payload: Partial<Promo>) => api.post("/api/admin/promos", payload),
  updatePromo: (id: number | string, payload: Partial<Promo>) => api.put(`/api/admin/promos/${id}`, payload),
  deletePromo: (id: number | string) => api.delete(`/api/admin/promos/${id}`),
  
  getRagStatus: () => api.get<RagStatus>("/api/admin/rag/status"),
  syncRag: () => api.post<{ success: boolean; message: string }>("/api/admin/rag/sync", {}),
  getChatSessions: (qs: string = "") => api.get<ChatSession[]>(`/api/admin/chats${qs}`),
};

