within MovingBoundaryLibrary.Tests.TestCondenser;
model Test_cond_SH
  replaceable package Medium = ExternalMedia.Examples.WaterCoolProp;
  MovingBoundaryLibrary.Components.Cells.OnePhase onePhaseTotal(
    redeclare package Medium = Medium,
    Type=false,
    AA=0.0019,
    YY=1.57,
    Ltotal=500,
    Mdotnom=0.5,
    Unom=2500,
    lstart=500,
    subcooled=false,
    eps_NTU=true,
    pstart=6000000,
    hstart=4E6)
    annotation (Placement(transformation(extent={{-22,-50},{18,-10}})));
  Components.SecondaryFluid.SecondaryFluid secondaryFluid(
    n=1,
    Usf=1000,
    AA=0.0019,
    YY=1.57,
    L_total=500,
    eps_NTU=false,
    Tstart=1153.15,
    DTstart=283.15)
    annotation (Placement(transformation(extent={{-22,20},
            {20,60}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                         Medium,
    Mdot_0=0.5,
    p=6000000,
    T_0=1173.15)
    annotation (Placement(transformation(extent={{-84,-30},
            {-64,-10}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(Mdot_0=3,
      T_0=1153.15)
    annotation (Placement(transformation(extent={{18,74},{38,94}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                       Medium, p0=
       6000000)
    annotation (Placement(transformation(extent={{78,10},
            {98,30}})));
equation
  connect(sourceMdot.flangeB, onePhaseTotal.inFlow) annotation (Line(
      points={{-65,-20},{-40,-20},{-40,-30},{-22,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot.flange, secondaryFluid.InFlow_sf) annotation (Line(
      points={{36.2,83.9},{52,83.9},{52,40},{17.9,40}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(onePhaseTotal.outFlow, sinkP.flangeB) annotation (Line(
      points={{18,-29.8},{40,-29.8},{40,20},{79.6,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(secondaryFluid.mbIn[1], onePhaseTotal.mbOut)
    annotation (Line(
      points={{-1,21.6},{-1,0},{-2,0},{-2,-12}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Test_cond_SH;
