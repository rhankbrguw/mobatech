package cron

import (
	"fmt"
	"time"
)

func parseScheduleEnd(date time.Time, endTime string) (time.Time, error) {
	scheduleEndStr := fmt.Sprintf("%s %s", date.Format("2006-01-02"), endTime)
	if len(endTime) > 5 {
		return time.ParseInLocation("2006-01-02 15:04:05", scheduleEndStr, time.Local)
	}
	return time.ParseInLocation("2006-01-02 15:04", scheduleEndStr, time.Local)
}
