within Components.Units.HeatExchangers.MovingBoundary.Materials;
record MetalWall "Metal properties"
  extends BaseClasses.BaseWallProperties(
  final cp = 1,
  final rho= 1,
  final lambda=1);
end MetalWall;
