within MovingBoundaryLibrary.Tests.TestEvaporator;
model TestCasella
  replaceable package Medium =
      ThermoCycle.Media.SES36_CP;
  ORC.Components.MBevaporator mBevaporator(redeclare package Medium = Medium,
    gammaA=3000,
    gammaB=8700,
    gammaC=3000,
    Gmean=0.8,
    Cw=500,
    A=16.18,
    LA(start=22),
    LB(start=44),
    hOUT(start=256022),
    usederL=true,
    Mtot=6,
    Ltot=66.6,
    W=0.4918,
    p(start=804749),
    TwA(start=373.15),
    TwB(start=385.15),
    TwC(start=398.15)) annotation (Placement(transformation(extent={{-22,-26},{16,-6}})));
  ORC.Components.DHT2MBHT dHT2MBHT(
    N=10,
    Stot=16.18,
    Ltot=66.6)  annotation (Placement(transformation(extent={{-14,46},{6,26}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                        Medium,
    Mdot_0=0.3061,
    T_0=355.27)
    annotation (Placement(transformation(extent={{-82,-24},{-62,-4}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium = Medium, p0=804749)
    annotation (Placement(transformation(extent={{68,-18},{88,2}})));
  ThermoCycle.Components.FluidFlow.Pipes.Flow1DConst flow1DConst(
    N=10,
    A=16.18,
    Mdotnom=3.147,
    Unom=1000,
    Tstart_inlet=398.15,
    Tstart_outlet=389.45) annotation (Placement(transformation(extent={{10,86},{-10,66}})));
  inner ThermoPower.System system annotation (Placement(transformation(extent={{60,68},{80,88}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    Mdot_0=3.147,
    T_0=398.15,
    cp=1907,
    rho=937.952) annotation (Placement(transformation(extent={{12,80},{32,100}})));
equation
  connect(dHT2MBHT.mh, mBevaporator.mbhtb)
    annotation (Line(
      points={{-4,26.2},{-4,-11.4},{-3,-11.4}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, mBevaporator.inletCold) annotation (Line(
      points={{-63,-14},{-44,-14},{-44,-16},{-22,-16}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot.flange, flow1DConst.flange_Cdot) annotation (Line(
      points={{30.2,89.9},{38,89.9},{38,76},{10,76}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(flow1DConst.Wall_int, dHT2MBHT.dHT)
    annotation (Line(
      points={{0,71},{0,64},{-4.1,64},{-4.1,46}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(mBevaporator.outletCold, sinkP.flangeB) annotation (Line(
      points={{16,-16},{44,-16},{44,-2},{69.6,-2},{69.6,-8}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end TestCasella;
