within Components.Units.HeatExchangers.MovingBoundary.Materials;
record AluminumWall "Aluminum properties"
  extends BaseClasses.BaseWallProperties(
  final cp = 902,
  final rho= 2700,
  final lambda=205);
end AluminumWall;
