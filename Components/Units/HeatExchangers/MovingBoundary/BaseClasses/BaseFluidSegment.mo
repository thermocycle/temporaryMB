within Components.Units.HeatExchangers.MovingBoundary.BaseClasses;
model BaseFluidSegment
  extends Modelica.Fluid.Pipes.DynamicPipe(
    final nNodes=1,
    final useLumpedPressure=false,
    final use_HeatTransfer=true,
    final modelStructure=Modelica.Fluid.Types.ModelStructure.a_v_b,
  final nParallel=1,
  final isCircular=true,
  final crossArea=Modelica.Constants.pi*diameter*diameter/4,
  final perimeter=Modelica.Constants.pi*diameter);

end BaseFluidSegment;
