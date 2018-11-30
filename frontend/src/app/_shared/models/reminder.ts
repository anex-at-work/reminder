export class Reminder {
  id?: number;
  title: string;
  description?: string;
  date_at?: Date;
  time_at: string;
  user_date?: string;
  repeat_type: string;
  calculated_date?: string[];
  parent_id?: number;
}
