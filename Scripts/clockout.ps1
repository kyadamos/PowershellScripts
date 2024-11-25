## Clockout function: Given the clock-in, meal start, & meal end times, calculates the clock-out time required to work 8 hours
function clockout
{
	[CmdletBinding(SupportsShouldProcess=$True)]
	param(
		[Parameter(Position=0,Mandatory=$true)]
		[uint16] $shiftStartTime,
		[Parameter(Position=1,mandatory=$true)]
		[uint16] $mealStartTime,
		[Parameter(Position=2,mandatory=$true)]
		[uint16] $mealEndTime,
		[Parameter()]
		[switch]$popup
	)
	process
	{
		
		$clockTimeObject = @($shiftStartTime,$mealStartTime,$mealEndTime)
		
		$hours, $minutes = @(), @()
		
		foreach ($time in $clockTimeObject) {
			$hour = ($time - ($time % 100)) / 100
			$minute = $time % 100
			$hours += $hour
			$minutes += $minute
		}
	
		$worked_hours_by_lunch = $hours[1] - $hours[0]
		$worked_minutes_by_lunch = $minutes[1] - $minutes[0]
		switch ($worked_minutes_by_lunch){
			{$_ -ge 60}{
				$worked_hours_by_lunch += 1
				$worked_minutes_by_lunch %= 60
				Break
			}
			{$_ -eq 0}{
				$worked_minutes_by_lunch = 0
			}
			{$_ -lt 0}{
				$worked_hours_by_lunch -= 1
				$worked_minutes_by_lunch += 60
				Break
				}
		}
		
		$end_hour = 7 - $worked_hours_by_lunch + $hours[2]
		$end_minute = (60 - $worked_minutes_by_lunch) + $minutes[2]
		
		if ($end_minute -ge 60) {
			$end_hour += 1
			$end_minute %= 60
		}
		
		$end_time = $end_hour * 100 + $end_minute # combine hours and minutes into one value
		write-host $end_time
		if ($popup) {
			[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
			[System.Windows.Forms.MessageBox]::Show("clockout at $($end_time.ToString().Substring(0,2)):$($end_time.ToString().Substring(2,2))", "clockout:")
		}
	}
}