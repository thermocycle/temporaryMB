within MovingBoundaryLibrary.Tests.TestEvaporator.TestFlooded;
model Test_FloodedWall
  replaceable package Medium =
     ExternalMedia.Examples.WaterCoolProp;

  Components.Evaporator.EvaFlooded evaFlooded(
    redeclare package Medium = Medium,
    Ltotal=500,
    lstartSC=50,
    lstartTP=450,
    hstartTP=1.8E6,
    Mdotnom=0.5,
    eps_NTU=false,
    pstart=3000000) annotation (Placement(transformation(extent={{-6,-26},{14,
            -6}})));
  Components.SecondaryFluid.SecondaryFluid secondaryFluidDouble(
    Usf=1000,
    n=n,
    AA=0.0019,
    YY=1.57,
    L_total=500,
    eps_NTU=false,
    Tstart=523.15,
    DTstart=323.15) annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot2(
                                                                    redeclare
      package Medium =                                                                        Medium,
    Mdot_0=0.5,
    p=150000,
    T_0=300.15)
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    cp=4000,
    Mdot_0=15,
    T_0=523.15)
             annotation (Placement(transformation(extent={{8,74},{28,94}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(
                                                          redeclare package
      Medium =                                                                       Medium,
    h=1.8E6,
    p0=3000000)
    annotation (Placement(transformation(extent={{70,-20},{90,0}})));
    parameter Integer n=2;
parameter Boolean counterCurrent = true;
  Components.Wall.wall2volumes wall2volumes(
    L_total=500,
    M_w=80,
    cp_w=500,
    TstartWall={513.15,513.15}) annotation (Placement(transformation(extent={{-10,12},{10,32}})));
equation

  /* If statement to allow parallel or counter current structure*/
if counterCurrent then
connect( wall2volumes.QmbOut, secondaryFluidDouble.mbIn[n:-1:1]);
else
  connect(wall2volumes.QmbOut, secondaryFluidDouble.mbIn);
end if;

  connect(sourceCdot.flange, secondaryFluidDouble.InFlow_sf)
    annotation (Line(
      points={{26.2,83.9},{42,83.9},{42,50},{9,50}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(evaFlooded.mbOut, wall2volumes.QmbIn) annotation (Line(
      points={{4,-7},{4,13},{-0.8,13}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sourceMdot2.flangeB, evaFlooded.InFlow) annotation (Line(
      points={{-61,-20},{-32,-20},{-32,-16},{-6.4,-16}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaFlooded.OutFlow, sinkP1.flangeB) annotation (Line(
      points={{13.8,-15.8},{30,-15.8},{30,-10},{71.6,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),                                                                     graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end Test_FloodedWall;
