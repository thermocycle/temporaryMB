within Components.Units.HeatExchangers.MovingBoundary.Materials;
record DefaultWall "Default properties (steel)"
  extends BaseClasses.BaseWallProperties(
  cp = 1,
  rho= 1,
  lambda=1);
end DefaultWall;
