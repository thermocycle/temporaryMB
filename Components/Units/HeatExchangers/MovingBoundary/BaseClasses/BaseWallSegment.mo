within Components.Units.HeatExchangers.MovingBoundary.BaseClasses;
model BaseWallSegment
  extends Modelica.Fluid.Examples.HeatExchanger.BaseClasses.WallConstProps(
  final n = 1, final m=fill(rho_wall*area_h*s/n,n));
end BaseWallSegment;
