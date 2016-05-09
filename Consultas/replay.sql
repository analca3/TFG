SELECT AB.Frame
	,@minerals := IFNULL(Minerals, @minerals) AS Minerals
	,@gas := IFNULL(Gas, @gas) AS Gas
	,@supply := IFNULL(Supply, @supply) AS Supply
	,@totMinerals := IFNULL(TotalMinerals, @totMinerals) AS TotalMinerals
	,@totGas := IFNULL(TotalGas, @totGas) AS TotalGas
	,@totSupply := IFNULL(TotalSupply, @totSupply) AS TotalSupply
	,@winnerA := IFNULL(WinnerA, @winnerA) AS WinnerA
	,@enemyMinerals := IFNULL(EnemyMinerals, @enemyMinerals) AS EnemyMinerals
	,@enemyGas := IFNULL(EnemyGas, @enemyGas) AS EnemyGas
	,@enemySupply := IFNULL(EnemySupply, @enemySupply) AS EnemySupply
	,@enemyTotMinerals := IFNULL(EnemyTotalMinerals, @enemyTotMinerals) AS EnemyTotalMinerals
	,@enemyTotGas := IFNULL(EnemyTotalGas, @enemyTotGas) AS EnemyTotalGas
	,@enemyTotSupply := IFNULL(EnemyTotalSupply, @enemyTotSupply) AS EnemyTotalSupply
	,@winnerB := IFNULL(WinnerB, @winnerB) AS WinnerB
	,@ground := IFNULL(GroundUnitValue, @ground) AS GroundUnitValue
	,@building := IFNULL(BuildingValue, @building) AS BuildingValue
	,@air := IFNULL(AirUnitValue, @air) AS AirUnitValue
	,@enemyGround := IFNULL(EnemyGroundUnitValue, @enemyGround) AS EnemyGroundUnitValue
	,@enemyBuilding := IFNULL(EnemyBuildingValue, @enemyBuilding) AS EnemyBuildingValue
	,@enemyAir := IFNULL(EnemyAirUnitValue, @enemyAir) AS EnemyAirUnitValue
	,ResourceValue
FROM (
	SELECT IFNULL(A.Frame, B.Frame) AS Frame
		,A.Minerals
		,A.Gas
		,A.Supply
		,A.TotalMinerals
		,A.TotalGas
		,A.TotalSupply
		,A.Winner AS WinnerA
		,B.Minerals AS EnemyMinerals
		,B.Gas AS EnemyGas
		,B.Supply AS EnemySupply
		,B.TotalMinerals AS EnemyTotalMinerals
		,B.TotalGas AS EnemyTotalGas
		,B.TotalSupply AS EnemyTotalSupply
		,B.Winner AS WinnerB
	FROM (
		SELECT rc.Frame
			,pr.PlayerReplayID
			,rc.Minerals
			,rc.Gas
			,rc.Supply
			,rc.TotalMinerals
			,rc.TotalGas
			,rc.TotalSupply
			,pr.Winner
		FROM resourcechange rc
		INNER JOIN playerreplay pr
			ON pr.PlayerReplayID = rc.PlayerReplayID
		INNER JOIN replay r
			ON r.ReplayID = pr.ReplayID
		WHERE r.ReplayID = 266
			AND pr.PlayerReplayID = 543
		-- AND Frame > 0
		ORDER BY rc.Frame ASC
		) AS A
	LEFT JOIN (
		SELECT rc.Frame
			,pr.PlayerReplayID
			,rc.Minerals
			,rc.Gas
			,rc.Supply
			,rc.TotalMinerals
			,rc.TotalGas
			,rc.TotalSupply
			,pr.Winner
		FROM resourcechange rc
		INNER JOIN playerreplay pr
			ON pr.PlayerReplayID = rc.PlayerReplayID
		INNER JOIN replay r
			ON r.ReplayID = pr.ReplayID
		WHERE r.ReplayID = 266
			AND pr.PlayerReplayID = 544
		-- AND Frame > 0
		ORDER BY rc.Frame ASC
		) AS B
		ON A.Frame = B.Frame
			AND A.PlayerReplayID != B.PlayerReplayID
	
	UNION ALL
	
	SELECT IFNULL(A.Frame, B.Frame) AS Frame
		,A.Minerals
		,A.Gas
		,A.Supply
		,A.TotalMinerals
		,A.TotalGas
		,A.TotalSupply
		,A.Winner AS WinnerA
		,B.Minerals
		,B.Gas
		,B.Supply
		,B.TotalMinerals AS EnemyTotalMinerals
		,B.TotalGas AS EnemyTotalGas
		,B.TotalSupply AS EnemyTotalSupply
		,B.Winner AS WinnerB
	FROM (
		SELECT rc.Frame
			,pr.PlayerReplayID
			,rc.Minerals
			,rc.Gas
			,rc.Supply
			,rc.TotalMinerals
			,rc.TotalGas
			,rc.TotalSupply
			,pr.Winner
		FROM resourcechange rc
		INNER JOIN playerreplay pr
			ON pr.PlayerReplayID = rc.PlayerReplayID
		INNER JOIN replay r
			ON r.ReplayID = pr.ReplayID
		WHERE r.ReplayID = 266
			AND pr.PlayerReplayID = 543
		-- AND Frame > 0
		ORDER BY rc.Frame ASC
		) AS A
	RIGHT JOIN (
		SELECT rc.Frame
			,pr.PlayerReplayID
			,rc.Minerals
			,rc.Gas
			,rc.Supply
			,rc.TotalMinerals
			,rc.TotalGas
			,rc.TotalSupply
			,pr.Winner
		FROM resourcechange rc
		INNER JOIN playerreplay pr
			ON pr.PlayerReplayID = rc.PlayerReplayID
		INNER JOIN replay r
			ON r.ReplayID = pr.ReplayID
		WHERE r.ReplayID = 266
			AND pr.PlayerReplayID = 544
		-- AND Frame > 0
		ORDER BY rc.Frame ASC
		) AS B
		ON A.Frame = B.Frame
			AND A.PlayerReplayID != B.PlayerReplayID
	WHERE A.Frame IS NULL
	) AS AB
LEFT JOIN (
	SELECT DISTINCT rc.Frame
		,sum(GroundUnitValue) AS GroundUnitValue
		,sum(BuildingValue) AS BuildingValue
		,sum(AirUnitValue) AS AirUnitValue
		,sum(EnemyGroundUnitValue) AS EnemyGroundUnitValue
		,sum(EnemyBuildingValue) AS EnemyBuildingValue
		,sum(EnemyAirUnitValue) AS EnemyAirUnitValue
		,sum(ResourceValue) AS ResourceValue
	FROM resourcechange rc
	INNER JOIN regionvaluechange AS R1
		ON rc.PlayerReplayID = R1.PlayerReplayID
	WHERE rc.PlayerReplayID = 543
		AND R1.Frame = (
			SELECT max(Frame)
			FROM regionvaluechange
			WHERE PlayerReplayID = 543
				AND RegionID = R1.RegionID
				AND Frame <= rc.Frame
			GROUP BY RegionID
			)
	-- and rc.Frame > 0 
	GROUP BY rc.Frame
	ORDER BY rc.Frame
	) AS C
	ON AB.Frame = C.Frame
CROSS JOIN (
	SELECT @minerals := 0
		,@gas := 0
		,@supply := 0
		,@enemyMinerals := 0
		,@enemyGas := 0
		,@enemySupply := 0
		,@totMinerals := 0
		,@totGas := 0
		,@totSupply := 0
		,@winnerA := 0
		,@enemyTotMinerals := 0
		,@enemyTotGas := 0
		,@enemyTotSupply := 0
		,@winnerB := 0
		,@ground := 0
		,@building := 0
		,@air := 0
		,@enemyGround := 0
		,@enemyBuilding := 0
		,@enemyAir := 0
	) AS var_init
ORDER BY AB.Frame;