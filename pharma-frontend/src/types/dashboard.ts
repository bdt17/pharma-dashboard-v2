export interface DashboardMetrics {
  shipments_today: number;
  otif_rate: string;
  avg_temp: number;
  compliance_rate: string;
  active_carriers: number;
  critical_alerts: number;
}

export interface Prediction {
  risk_score: number;
  risk_level: string;
  predicted_temp: string;
}

export interface ApiResponse<T = any> {
  success: boolean;
  data: T;
  error?: string;
}
