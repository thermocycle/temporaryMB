within Components.Units.HeatExchangers.MovingBoundary.Materials;
record DefaultWall "Default properties (steel)"
  extends BaseClasses.BaseWallProperties(
  cp = 500,
  rho= 7.83,
  lambda=16.3);
end DefaultWall;
