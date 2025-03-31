return {
	"gaborvecsei/usage-tracker.nvim",
	event = "VeryLazy",
	config = {
		keep_eventlog_days = 365,
		cleanup_freq_days = 365,
		event_wait_period_in_sec = 3,
		inactivity_threshold_in_min = 15,
		inactivity_check_freq_in_sec = 5,
		verbose = 0,
		telemetry_endpoint = "", -- you'll need to start the restapi for this feature
	},
}
