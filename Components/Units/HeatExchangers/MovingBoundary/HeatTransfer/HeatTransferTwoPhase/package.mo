within Components.Units.HeatExchangers.MovingBoundary.HeatTransfer;
package HeatTransferTwoPhase "A collection of heat transfer correlations for twophase flow"
  extends
  Components.Units.HeatExchangers.MovingBoundary.HeatTransfer.IdealHeatTransfer;


  annotation (Icon(graphics={        Ellipse(
            extent={{0,60},{60,0}},
            lineColor={0,0,0},
            fillPattern=FillPattern.Sphere,
        fillColor={159,159,223},
        startAngle=0,
        endAngle=181),               Ellipse(
            extent={{0,60},{60,0}},
            lineColor={0,0,0},
            fillPattern=FillPattern.Sphere,
        startAngle=179,
        endAngle=361),
      Rectangle(
        extent={{0,32},{60,28}},
        fillColor={85,85,255},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0})}));
end HeatTransferTwoPhase;
