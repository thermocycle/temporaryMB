within MovingBoundaryLibrary.Tests.TestEvaporator;
model GeneralBonillaPdrop
  import Modelica.SIunits;
  // Parameters
  parameter SIunits.MassFlowRate mdot0 = 0.5;
  parameter SIunits.Temperature TAmb=290;
  parameter SIunits.Temperature Tin=350;
  //parameter SIunits.Temperature Tw1=461;
  //parameter SIunits.Temperature Tw2=554;
  //parameter SIunits.Temperature Tw3=600;
  parameter SIunits.Length PTC_Height = 2.4;
  parameter SIunits.Length Di = 0.05;
  parameter SIunits.Length Do = 0.07;
  parameter SIunits.Length Ltotal = 500;
  parameter SIunits.Pressure pout = 6e6;
  parameter SIunits.Pressure p_ex = 5.8e6;
  parameter SIunits.Temperature Tout3=580;
  parameter SIunits.SpecificHeatCapacity cpw = 500;
  parameter SIunits.Density dw = 7780;
  parameter SIunits.CoefficientOfHeatTransfer htc1=2500;
  parameter SIunits.CoefficientOfHeatTransfer htc2=8000;
  parameter SIunits.CoefficientOfHeatTransfer htc3=2000;
  parameter SIunits.SpecificEnthalpy h0 = GeneralEvaporator.Medium.specificEnthalpy_pT(pout, Tin);
  parameter Modelica.SIunits.Emissivity epsilon = 0.1;

  Modelica.Media.Interfaces.PartialTwoPhaseMedium.SaturationProperties
            sat(psat=pout,Tsat=GeneralEvaporator.Medium.saturationTemperature(sat.psat));
  MBMs.Components.Water.MBM.Evaporators.General
  GeneralEvaporator(
    Ltotal = Ltotal,
    redeclare package Medium =
      Modelica.Media.Water.StandardWater,
    v1(
      g=cylindrical_Geometry1,
      redeclare model HTC_Model =
        MBMs.Components.Water.HeatTransfer.OnePhase.Evaporation.Constant (
            alpha_cte=htc1),
      redeclare model Friction_Model =
        MBMs.Components.Water.FanningFrictionFactor.Constant (  f_cte=0.001)),
    v2(
      g=cylindrical_Geometry2,
      redeclare model HTC_Model =
        MBMs.Components.Water.HeatTransfer.TwoPhase.Evaporation.Constant (
            alpha_cte=htc2),
      redeclare model Friction_Model =
        MBMs.Components.Water.FanningFrictionFactor.Constant (  f_cte=0.001)),
    v3(
      g=cylindrical_Geometry3,
      redeclare model HTC_Model =
        MBMs.Components.Water.HeatTransfer.OnePhase.Evaporation.Constant (
            alpha_cte=htc3),
      redeclare model Friction_Model =
        MBMs.Components.Water.FanningFrictionFactor.Constant (  f_cte=0.001)),
    p0=pout,
      ha_der=true,
      ha_port=false,
      pb_port=false)
 annotation (Placement(transformation(extent={{-36,-104},{40,-40}},
        rotation=0)));

  MBMs.Components.Geometry.cylindrical_Geometry cylindrical_Geometry1(Di=Di, Do=Do)
    annotation (Placement(transformation(extent={{20,60},{40,80}}, rotation=0)));
  MBMs.Components.Geometry.cylindrical_Geometry cylindrical_Geometry2(Di=Di, Do=Do)
    annotation (Placement(transformation(extent={{40,60},{60,80}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Ambient(
                                                         T=TAmb)
    annotation (Placement(transformation(
      origin={84,45},
      extent={{-8,-8},{8,8}},
      rotation=180)));
  Modelica.Blocks.Sources.RealExpression Subcooled_Zone_Area(y=PTC_Height
      *cylindrical_Geometry1.Li) annotation (Placement(transformation(
        extent={{-95,37},{-55,59}}, rotation=0)));
  Modelica.Blocks.Sources.RealExpression TwoPhase_Zone_Area(y=PTC_Height*
      cylindrical_Geometry2.Li)  annotation (Placement(transformation(
        extent={{-95,21},{-55,43}},rotation=0)));
  MBMs.Components.Walls.cylindrical_wall cylindricalWall(
    dw={dw,dw,dw},
    cpw={cpw,cpw,cpw},
    cg={cylindrical_Geometry1,cylindrical_Geometry2,cylindrical_Geometry3},
      n=GeneralEvaporator.nCV,
    cpw_sel=1)
             annotation (Placement(transformation(extent={{-33,-20},{36,
          30}}, rotation=0)));
  MBMs.Components.HeatFlow.TransferLaws.AmbientHeatTransfer aht_2p(epsilon={epsilon,epsilon,epsilon}, n=
        GeneralEvaporator.nCV) annotation (Placement(transformation(
        origin={43.5,45},
        extent={{-13,-11.5},{13,11.5}},
        rotation=90)));
  MBMs.Components.PTC.Receiver receiver(nCV=GeneralEvaporator.nCV)
    annotation (Placement(transformation(extent={{-27,68},{1,94}}, rotation=0)));
  Modelica.Blocks.Sources.RealExpression theta(y=0)
                                 annotation (Placement(transformation(
        extent={{-96,53},{-56,75}}, rotation=0)));
  Modelica.Blocks.Sources.RealExpression Inlet_mdot(y=mdot0)
                                 annotation (Placement(transformation(
        extent={{-96,-64},{-78,-47}},
                                    rotation=0)));
  Modelica.Fluid.Sources.MassFlowSource_h source(
    use_m_flow_in=true,
    use_h_in=true,
    nPorts=1,
    redeclare package Medium =
      Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-66,-82},{-46,-62}})));
  Modelica.Blocks.Sources.RealExpression Inlet_h(y=h0)
    annotation (Placement(transformation(extent={{-96,-94},{-78,-77}},rotation=0)));
  Modelica.Blocks.Sources.CombiTimeTable Irradiance(smoothness=Modelica.Blocks.
        Types.Smoothness.LinearSegments, table=[0.0,1200; 20000,1200; 24000,1100;
        50000,1100; 54000,1200; 80000,1200; 84000,1100; 110000,1100; 130000,1300;
        140000,1300])
    annotation (Placement(transformation(extent={{-96,74},{-76,94}},
        rotation=0)));
  Modelica.Blocks.Sources.RealExpression Superheated_Zone_Area(y=PTC_Height*
        cylindrical_Geometry3.Li)
                                 annotation (Placement(transformation(
        extent={{-95,5},{-55,27}}, rotation=0)));
  MBMs.Components.Geometry.cylindrical_Geometry cylindrical_Geometry3(Di=Di, Do=Do)
    annotation (Placement(transformation(extent={{60,60},{80,80}}, rotation=0)));
  Modelica.Blocks.Sources.RealExpression Pipe_Surface_SC(y=
        cylindrical_Geometry1.So)
                                 annotation (Placement(transformation(
        extent={{-94,-11},{-54,11}},rotation=0)));
  Modelica.Blocks.Sources.RealExpression Pipe_Surface_TP(y=
        cylindrical_Geometry2.So)
                                 annotation (Placement(transformation(
        extent={{-94,-27},{-54,-5}},rotation=0)));
  Modelica.Blocks.Sources.RealExpression Pipe_Surface_SS(y=
        cylindrical_Geometry3.So)
                                 annotation (Placement(transformation(
        extent={{-94,-43},{-54,-21}},
                                    rotation=0)));
  Modelica.Blocks.Sources.RealExpression Outlet_pressure(y=p_ex)
                                 annotation (Placement(transformation(
        extent={{66,-18},{84,-1}},  rotation=0)));
  Modelica.Fluid.Sources.Boundary_ph sink(
    redeclare package Medium =
      Modelica.Media.Water.StandardWater,
    use_p_in=true,
    nPorts=1)    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={84,-70})));
  ThermoPower.Water.ValveLin valveLin(                redeclare package Medium
      =
      Modelica.Media.Water.StandardWater,                                                                            Kv=2.5e-06)
    annotation (Placement(transformation(extent={{48,-94},{68,-74}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant Cmd_nom(k=1)
    annotation (Placement(transformation(extent={{18,-24},{34,-14}},
                                                                 rotation=
           0)));
  inner ThermoPower.System system annotation (Placement(transformation(extent={{96,6},{116,26}})));
initial equation
  der(cylindricalWall.Tw)      = {0,0,0};

equation
  GeneralEvaporator.mode[1] = MBMs.Constants.RM_COMPOUND;
  GeneralEvaporator.mode[2] = MBMs.Constants.RM_COMPOUND;
  GeneralEvaporator.mode[3] = MBMs.Constants.RM_COMPOUND;
  GeneralEvaporator.active  = {false,false,true};

  connect(Subcooled_Zone_Area.y, receiver.area[1]) annotation (Line(
    points={{-53,48},{-50,48},{-50,73.2},{-28.4,73.2}},
    color={0,0,127},
    thickness=0.5));
  connect(TwoPhase_Zone_Area.y, receiver.area[2]) annotation (Line(
    points={{-53,32},{-48,32},{-48,73.2},{-28.4,73.2}},
    color={0,0,127},
    thickness=0.5));
  connect(Superheated_Zone_Area.y, receiver.area[3]) annotation (Line(
    points={{-53,16},{-46,16},{-46,73.2},{-28.4,73.2}},
    color={0,0,127},
    thickness=0.5,
    smooth=Smooth.None));
  connect(Inlet_mdot.y, source.m_flow_in)  annotation (Line(
      points={{-77.1,-55.5},{-72,-55.5},{-72,-64},{-66,-64}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Inlet_h.y, source.h_in)   annotation (Line(
      points={{-77.1,-85.5},{-72,-85.5},{-72,-68},{-68,-68}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(GeneralEvaporator.a, source.ports[1])   annotation (Line(
      points={{-36,-72},{-46,-72}},
      color={0,127,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Irradiance.y[1], receiver.Irr) annotation (Line(
      points={{-75,84},{-58,84},{-58,88.8},{-28.12,88.8}},
      color={0,0,127},
      smooth=Smooth.None,
      thickness=0.5));
  connect(aht_2p.Qb[1], Ambient.port) annotation (Line(
      points={{54.885,45},{76,45}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(aht_2p.Qb[2], Ambient.port) annotation (Line(
      points={{54.885,45},{76,45}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(aht_2p.Qb[3], Ambient.port) annotation (Line(
      points={{54.885,45},{76,45}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(receiver.Q, cylindricalWall.Qa) annotation (Line(
      points={{1.14,81},{1.14,56.5},{1.5,56.5},{1.5,29.5}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(cylindricalWall.Qa, aht_2p.Qa) annotation (Line(
      points={{1.5,29.5},{1.5,45},{32.23,45}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(cylindricalWall.Qb, GeneralEvaporator.Q) annotation (Line(
      points={{1.5,-19.75},{1.5,-27.875},{2,-27.875},{2,-40}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(theta.y, receiver.theta) annotation (Line(
      points={{-54,64},{-54,81},{-28.4,81}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Pipe_Surface_SC.y, aht_2p.A[1]) annotation (Line(
      points={{-52,1.16573e-16},{-42,0},{-42,37.2},{30.85,37.2}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));

  connect(Pipe_Surface_TP.y, aht_2p.A[2]) annotation (Line(
      points={{-52,-16},{-42,-16},{-42,37.2},{30.85,37.2}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Pipe_Surface_SS.y, aht_2p.A[3]) annotation (Line(
      points={{-52,-32},{-42,-32},{-42,37.2},{30.85,37.2}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(sink.p_in,Outlet_pressure. y) annotation (Line(
      points={{96,-78},{98,-78},{98,-9.5},{84.9,-9.5}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(GeneralEvaporator.b, valveLin.inlet)
    annotation (Line(
      points={{40,-72},{48,-72},{48,-84}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valveLin.outlet, sink.ports[1])
    annotation (Line(
      points={{68,-84},{68,-70},{74,-70}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Cmd_nom.y, valveLin.cmd)
    annotation (Line(
      points={{34.8,-19},{58,-19},{58,-76}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                      graphics),
    experiment(StopTime=150000, Tolerance=1e-06),
    experimentSetupOutput,
    Icon(graphics={Text(
        extent={{-100,100},{98,-100}},
        lineColor={0,0,0},
          textString="G")}));
end GeneralBonillaPdrop;
