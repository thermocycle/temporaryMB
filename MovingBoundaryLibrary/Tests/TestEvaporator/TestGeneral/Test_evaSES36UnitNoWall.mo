within MovingBoundaryLibrary.Tests.TestEvaporator.TestGeneral;
model Test_evaSES36UnitNoWall
replaceable package Medium =
      ThermoCycle.Media.SES36_CP;
  Components.Evaporator.UnitNoWall.EvaG evaG(
    redeclare package Medium = Medium,
    Ltotal=66.6,
    AA=0.0007,
    YY=0.243,
    counterCurrent=true,
    Mdotnom=0.3061,
    UnomSC=3000,
    UnomTP=8700,
    UnomSH=3000,
    Unomsf=1000,
    hstartSC=8E4,
    hstartTP=2E5,
    hstartSH=256022,
    h_pf_out=256022,
    SteadyStatePF=false,
    Set_h_pf_out=false,
    epsNTU_sf=false,
    pstart=810927,
    lstartSC=16.6,
    lstartTP=40,
    lstartSH=10,
    Tstartsf=398.15,
    DTstartsf=278.15) annotation (Placement(transformation(extent={{-24,-36},{26,14}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                        Medium,
    Mdot_0=0.3061,
    T_0=293.27)
    annotation (Placement(transformation(extent={{-88,-42},{-68,-22}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                      Medium, p0=
       810927)
    annotation (Placement(transformation(extent={{88,-24},{108,-4}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    Mdot_0=3.147,
    T_0=398.15,
    cp=1907,
    rho=937.952)
    annotation (Placement(transformation(extent={{-2,30},{18,50}})));
equation
  connect(sourceMdot.flangeB, evaG.InFlowPF) annotation (Line(
      points={{-69,-32},{-36,-32},{-36,-26},{-23.5,-26}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaG.OutFlowPF, sinkP.flangeB) annotation (Line(
      points={{25.5,-25.5},{62,-25.5},{62,-14},{89.6,-14}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot.flange, evaG.InFlowSF) annotation (Line(
      points={{16.2,39.9},{60,39.9},{60,4},{25.5,4}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end Test_evaSES36UnitNoWall;
