within MovingBoundaryLibrary.Components.Condenser;
model CondFlooded
 replaceable package Medium =
      ExternalMedia.Examples.WaterCoolProp constrainedby
    Modelica.Media.Interfaces.PartialMedium
                                           annotation (choicesAllMatching=true);

 /* Components */
  Cells.OnePhase volumeSC(
    redeclare final package Medium = Medium,
    pstart=pstart,
    hstart=hstartSC,
    lstart=lstartSC,
    Mdotnom=Mdotnom,
    Unom=UnomSC,
    AA=AA,
    alone=false,
    YY=YY,
    subcooled=true,
    eps_NTU=eps_NTU,
    Ltotal=Ltotal,
    Type=false)
    annotation (Placement(transformation(extent={{28,-8},{48,12}})));
  Cells.TwoPhase volumeTP(
    redeclare final package Medium = Medium,
    pstart=pstart,
    hstart=hstartTP,
    lstart=lstartTP,
    Mdotnom=Mdotnom,
    Unom=UnomTP,
    AA=AA,
    alone=false,
    YY=YY,
    Ltotal=Ltotal,
    Flooded=true,
    General=false,
    final Type=false,
    VoidFraction=VoidFraction,
    VoidF=VoidF)
    annotation (Placement(transformation(extent={{-42,-8},{-22,12}})));
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare final package Medium =
               Medium)
    annotation (Placement(transformation(extent={{-112,-8},{-92,12}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow(  redeclare final package Medium
      =                                                                           Medium)
    annotation (Placement(transformation(extent={{88,-8},{108,12}})));

import MovingBoundaryLibrary.Records;

/* Parameters */
final parameter Integer  nCV= 2;
parameter Modelica.SIunits.Area AA = 0.0019 "Channel cross section";
parameter Modelica.SIunits.Length YY = 1.57 "Channel perimeter";
parameter Modelica.SIunits.Length Ltotal=500
    "Total length of the heat exchanger";

parameter Boolean VoidFraction = true
    "Set to true to calculate the void fraction to false to keep it constant";
parameter Real VoidF = 0.8 "Constantat void fraction" annotation (Dialog(enable= not VoidFraction));

/* Heat transfer */
parameter Modelica.SIunits.MassFlowRate Mdotnom=0 "Nominal fluid flow rate" annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer UnomSC=2500
    "SC - Nominal heat transfer coefficient"                                                  annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer UnomTP=9000
    "TP - Nominal heat transfer coefficient"                                                  annotation (Dialog(group = "Heat transfer"));
parameter Boolean eps_NTU = false "Set to true for eps-NTU heat transfer" annotation (Dialog(group = "Heat transfer"));

  /* Initial values */
  parameter Modelica.SIunits.Pressure pstart=6e6 "Fluid pressure start value"
    annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstartSC=1E5 "SC: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Length lstartSC=1 "SC:Start value of length"
    annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstartTP=1E5 "TP: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Length lstartTP=1 "TP:Start value of length"
    annotation (Dialog(tab="Initialization"));

  Records.Mode mode[nCV];

  Interfaces.MbOut mbOut[nCV] annotation (Placement(transformation(extent={{-10,80},{10,100}})));
equation
  volumeSC.mode = mode[nCV-1];
  volumeTP.mode = mode[nCV];

  mode[nCV-1] = Constants.ModeCompound;
  mode[nCV] = Constants.ModeCompound;
  /* Geometric constraints */
  volumeSC.ll + volumeTP.ll = Ltotal;
  volumeSC.la = 0;
  volumeSC.lb = volumeTP.la;

initial equation
// der(volumeSC.ll) = 0;

equation

  connect(InFlow, volumeTP.inFlow) annotation (Line(
      points={{-102,2},{-42,2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(volumeTP.outFlow, volumeSC.inFlow) annotation (Line(
      points={{-22,2.1},{0,2.1},{0,2},{28,2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(volumeSC.outFlow,OutFlow)  annotation (Line(
      points={{48,2.1},{68,2.1},{68,2},{98,2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(volumeTP.mbOut, mbOut[1]) annotation (Line(
      points={{-32,11},{-32,36},{0,36},{0,85}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(volumeSC.mbOut, mbOut[2]) annotation (Line(
      points={{38,11},{38,36},{0,36},{0,95}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end CondFlooded;
