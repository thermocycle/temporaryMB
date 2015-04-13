within MovingBoundaryLibrary.Tests.TestCondenser;
model Test_cond_SC
  replaceable package Medium =ExternalMedia.Examples.WaterCoolProp;
  MovingBoundaryLibrary.Components.Cells.OnePhase onePhaseTotal(
    redeclare package Medium = Medium,
    Type=false,
    subcooled=true,
    AA=0.0019,
    YY=1.57,
    Ltotal=500,
    Mdotnom=0.5,
    Unom=2500,
    lstart=500,
    pstart=6000000)
    annotation (Placement(transformation(extent={{-20,-56},{20,-16}})));
  Components.SecondaryFluid.SecondaryFluid secondaryFluid(
    n=1,
    Usf=1000,
    AA=0.0019,
    YY=1.57,
    L_total=500,
    eps_NTU=true,
    Tstart=313.15,
    DTstart=283.15)
    annotation (Placement(transformation(extent={{-8,36},{20,64}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                         Medium,
    Mdot_0=0.5,
    p=6000000,
    T_0=350.15)
    annotation (Placement(transformation(extent={{-88,-56},{-68,-36}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(Mdot_0=5,
      T_0=313.15)
    annotation (Placement(transformation(extent={{18,74},{38,94}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                       Medium,p0=6000000)
    annotation (Placement(transformation(extent={{46,-20},{66,0}})));
equation
  connect(sourceMdot.flangeB, onePhaseTotal.inFlow) annotation (Line(
      points={{-69,-46},{-44,-46},{-44,-36},{-20,-36}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot.flange, secondaryFluid.InFlow_sf) annotation (Line(
      points={{36.2,83.9},{52,83.9},{52,50},{18.6,50}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(onePhaseTotal.outFlow, sinkP.flangeB) annotation (Line(
      points={{20,-35.8},{32,-35.8},{32,-10},{47.6,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(secondaryFluid.mbIn[1], onePhaseTotal.mbOut)
    annotation (Line(
      points={{6,37.12},{6,18},{0,18},{0,-18}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Test_cond_SC;
