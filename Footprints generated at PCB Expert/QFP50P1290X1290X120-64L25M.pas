Var
    CurrentLib : IPCB_Library;

Procedure CreateSMDComponentPad(NewPCBLibComp : IPCB_LibComponent, Name : String, Layer : TLayer, X : Real, Y : Real, OffsetX : Real, OffsetY : Real,
                                TopShape : TShape, TopXSize : Real, TopYSize : Real, Rotation: Real, CRRatio : Real, PMExpansion : Real, SMExpansion : Real,
                                PMFromRules : Boolean, SMFromRules : Boolean);
Var
    NewPad                      : IPCB_Pad2;
    PadCache                    : TPadCache;

Begin
    NewPad := PcbServer.PCBObjectFactory(ePadObject, eNoDimension, eCreate_Default);
    NewPad.HoleSize := MMsToCoord(0);
    NewPad.Layer    := Layer;
    NewPad.TopShape := TopShape;
    if TopShape = eRoundedRectangular then
        NewPad.SetState_StackCRPctOnLayer(eTopLayer, CRRatio);
    NewPad.TopXSize := MMsToCoord(TopXSize);
    NewPad.TopYSize := MMsToCoord(TopYSize);
    NewPad.RotateBy(Rotation);
    NewPad.MoveToXY(MMsToCoord(X), MMsToCoord(Y));
    NewPad.Name := Name;

    Padcache := NewPad.GetState_Cache;
    if (PMExpansion <> 0) or (PMFromRules = False) then
    Begin
        Padcache.PasteMaskExpansionValid   := eCacheManual;
        Padcache.PasteMaskExpansion        := MMsToCoord(PMExpansion);
    End;
    if (SMExpansion <> 0) or (SMFromRules = False) then
    Begin
        Padcache.SolderMaskExpansionValid  := eCacheManual;
        Padcache.SolderMaskExpansion       := MMsToCoord(SMExpansion);
    End;
    NewPad.SetState_Cache              := Padcache;

    NewPCBLibComp.AddPCBObject(NewPad);
    PCBServer.SendMessageToRobots(NewPCBLibComp.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,NewPad.I_ObjectAddress);
End;

Procedure CreateComponentTrack(NewPCBLibComp : IPCB_LibComponent, X1 : Real, Y1 : Real, X2 : Real, Y2 : Real, Layer : TLayer, LineWidth : Real, IsKeepout : Boolean);
Var
    NewTrack                    : IPCB_Track;

Begin
    NewTrack := PcbServer.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
    NewTrack.X1 := MMsToCoord(X1);
    NewTrack.Y1 := MMsToCoord(Y1);
    NewTrack.X2 := MMsToCoord(X2);
    NewTrack.Y2 := MMsToCoord(Y2);
    NewTrack.Layer := Layer;
    NewTrack.Width := MMsToCoord(LineWidth);
    NewTrack.IsKeepout := IsKeepout;
    NewPCBLibComp.AddPCBObject(NewTrack);
    PCBServer.SendMessageToRobots(NewPCBLibComp.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,NewTrack.I_ObjectAddress);
End;

Procedure CreateComponentArc(NewPCBLibComp : IPCB_LibComponent, CenterX : Real, CenterY: Real, Radius : Real, StartAngle : Real, EndAngle : Real, Layer : TLayer, LineWidth : Real, IsKeepout : Boolean);
Var
    NewArc                      : IPCB_Arc;

Begin
    NewArc := PCBServer.PCBObjectFactory(eArcObject,eNoDimension,eCreate_Default);
    NewArc.XCenter := MMsToCoord(CenterX);
    NewArc.YCenter := MMsToCoord(CenterY);
    NewArc.Radius := MMsToCoord(Radius);
    NewArc.StartAngle := StartAngle;
    NewArc.EndAngle := EndAngle;
    NewArc.Layer := Layer;
    NewArc.LineWidth := MMsToCoord(LineWidth);
    NewArc.IsKeepout := IsKeepout;
    NewPCBLibComp.AddPCBObject(NewArc);
    PCBServer.SendMessageToRobots(NewPCBLibComp.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,NewArc.I_ObjectAddress);
End;

Procedure CreateComponentQFP50P1290X1290X120_64L25M(Zero : integer);
Var
    NewPCBLibComp               : IPCB_LibComponent;
    NewPad                      : IPCB_Pad2;
    NewRegion                   : IPCB_Region;
    NewContour                  : IPCB_Contour;
    STEPmodel                   : IPCB_ComponentBody;
    Model                       : IPCB_Model;

Begin
    Try
        PCBServer.PreProcess;

        NewPCBLibComp := PCBServer.CreatePCBLibComp;
        NewPcbLibComp.Name := 'QFP50P1290X1290X120-64L25M';
        NewPCBLibComp.Description := 'Quad Flat Pack (QFP), 0.50 mm pitch; square, 16 pin X 16 pin, 10.00 mm L X 10.00 mm W X 1.20 mm H body';
        NewPCBLibComp.Height := MMsToCoord(1.2);

        CreateSMDComponentPad(NewPCBLibComp, '1', eTopLayer, -3.75, -6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 270, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '2', eTopLayer, -3.25, -6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 270, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '3', eTopLayer, -2.75, -6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 270, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '4', eTopLayer, -2.25, -6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 270, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '5', eTopLayer, -1.75, -6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 270, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '6', eTopLayer, -1.25, -6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 270, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '7', eTopLayer, -0.75, -6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 270, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '8', eTopLayer, -0.25, -6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 270, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '9', eTopLayer, 0.25, -6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 270, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '10', eTopLayer, 0.75, -6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 270, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '11', eTopLayer, 1.25, -6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 270, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '12', eTopLayer, 1.75, -6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 270, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '13', eTopLayer, 2.25, -6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 270, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '14', eTopLayer, 2.75, -6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 270, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '15', eTopLayer, 3.25, -6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 270, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '16', eTopLayer, 3.75, -6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 270, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '17', eTopLayer, 6.03, -3.75, 0, 0, eRoundedRectangular, 2.15, 0.34, 0, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '18', eTopLayer, 6.03, -3.25, 0, 0, eRoundedRectangular, 2.15, 0.34, 0, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '19', eTopLayer, 6.03, -2.75, 0, 0, eRoundedRectangular, 2.15, 0.34, 0, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '20', eTopLayer, 6.03, -2.25, 0, 0, eRoundedRectangular, 2.15, 0.34, 0, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '21', eTopLayer, 6.03, -1.75, 0, 0, eRoundedRectangular, 2.15, 0.34, 0, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '22', eTopLayer, 6.03, -1.25, 0, 0, eRoundedRectangular, 2.15, 0.34, 0, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '23', eTopLayer, 6.03, -0.75, 0, 0, eRoundedRectangular, 2.15, 0.34, 0, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '24', eTopLayer, 6.03, -0.25, 0, 0, eRoundedRectangular, 2.15, 0.34, 0, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '25', eTopLayer, 6.03, 0.25, 0, 0, eRoundedRectangular, 2.15, 0.34, 0, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '26', eTopLayer, 6.03, 0.75, 0, 0, eRoundedRectangular, 2.15, 0.34, 0, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '27', eTopLayer, 6.03, 1.25, 0, 0, eRoundedRectangular, 2.15, 0.34, 0, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '28', eTopLayer, 6.03, 1.75, 0, 0, eRoundedRectangular, 2.15, 0.34, 0, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '29', eTopLayer, 6.03, 2.25, 0, 0, eRoundedRectangular, 2.15, 0.34, 0, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '30', eTopLayer, 6.03, 2.75, 0, 0, eRoundedRectangular, 2.15, 0.34, 0, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '31', eTopLayer, 6.03, 3.25, 0, 0, eRoundedRectangular, 2.15, 0.34, 0, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '32', eTopLayer, 6.03, 3.75, 0, 0, eRoundedRectangular, 2.15, 0.34, 0, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '33', eTopLayer, 3.75, 6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 90, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '34', eTopLayer, 3.25, 6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 90, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '35', eTopLayer, 2.75, 6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 90, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '36', eTopLayer, 2.25, 6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 90, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '37', eTopLayer, 1.75, 6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 90, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '38', eTopLayer, 1.25, 6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 90, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '39', eTopLayer, 0.75, 6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 90, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '40', eTopLayer, 0.25, 6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 90, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '41', eTopLayer, -0.25, 6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 90, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '42', eTopLayer, -0.75, 6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 90, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '43', eTopLayer, -1.25, 6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 90, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '44', eTopLayer, -1.75, 6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 90, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '45', eTopLayer, -2.25, 6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 90, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '46', eTopLayer, -2.75, 6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 90, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '47', eTopLayer, -3.25, 6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 90, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '48', eTopLayer, -3.75, 6.03, 0, 0, eRoundedRectangular, 2.15, 0.34, 90, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '49', eTopLayer, -6.03, 3.75, 0, 0, eRoundedRectangular, 2.15, 0.34, 180, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '50', eTopLayer, -6.03, 3.25, 0, 0, eRoundedRectangular, 2.15, 0.34, 180, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '51', eTopLayer, -6.03, 2.75, 0, 0, eRoundedRectangular, 2.15, 0.34, 180, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '52', eTopLayer, -6.03, 2.25, 0, 0, eRoundedRectangular, 2.15, 0.34, 180, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '53', eTopLayer, -6.03, 1.75, 0, 0, eRoundedRectangular, 2.15, 0.34, 180, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '54', eTopLayer, -6.03, 1.25, 0, 0, eRoundedRectangular, 2.15, 0.34, 180, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '55', eTopLayer, -6.03, 0.75, 0, 0, eRoundedRectangular, 2.15, 0.34, 180, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '56', eTopLayer, -6.03, 0.25, 0, 0, eRoundedRectangular, 2.15, 0.34, 180, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '57', eTopLayer, -6.03, -0.25, 0, 0, eRoundedRectangular, 2.15, 0.34, 180, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '58', eTopLayer, -6.03, -0.75, 0, 0, eRoundedRectangular, 2.15, 0.34, 180, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '59', eTopLayer, -6.03, -1.25, 0, 0, eRoundedRectangular, 2.15, 0.34, 180, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '60', eTopLayer, -6.03, -1.75, 0, 0, eRoundedRectangular, 2.15, 0.34, 180, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '61', eTopLayer, -6.03, -2.25, 0, 0, eRoundedRectangular, 2.15, 0.34, 180, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '62', eTopLayer, -6.03, -2.75, 0, 0, eRoundedRectangular, 2.15, 0.34, 180, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '63', eTopLayer, -6.03, -3.25, 0, 0, eRoundedRectangular, 2.15, 0.34, 180, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '64', eTopLayer, -6.03, -3.75, 0, 0, eRoundedRectangular, 2.15, 0.34, 180, 52.94, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, 'FID1', eTopLayer, 6.03, -6.03, 0, 0, eRounded, 1, 1, 0, 0, -1, 0.5, True, True);
        CreateSMDComponentPad(NewPCBLibComp, 'FID2', eTopLayer, -6.03, 6.03, 0, 0, eRounded, 1, 1, 0, 0, -1, 0.5, True, True);

        CreateComponentArc(NewPCBLibComp, 6.03, -6.03, 1, 0, 360, eTopLayer, 0.025, True);
        CreateComponentArc(NewPCBLibComp, -6.03, 6.03, 1, 0, 360, eTopLayer, 0.025, True);
        CreateComponentArc(NewPCBLibComp, 0, 0, 0.25, 0, 360, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 0, 0.35, 0, -0.35, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -0.35, 0, 0.35, 0, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -5.1, -5.1, -5.1, 5.1, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, -5.1, 5.1, 5.1, 5.1, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, 5.1, 5.1, 5.1, -5.1, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, 5.1, -5.1, -5.1, -5.1, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, -4.42, -5.6, -4.42, -7.61, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -4.42, -7.61, 4.42, -7.61, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 4.42, -7.61, 4.42, -5.6, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 4.42, -5.6, 5.6, -5.6, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 5.6, -5.6, 5.6, -4.42, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 5.6, -4.42, 7.61, -4.42, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 7.61, -4.42, 7.61, 4.42, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 7.61, 4.42, 5.6, 4.42, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 5.6, 4.42, 5.6, 5.6, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 5.6, 5.6, 4.42, 5.6, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 4.42, 5.6, 4.42, 7.61, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 4.42, 7.61, -4.42, 7.61, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -4.42, 7.61, -4.42, 5.6, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -4.42, 5.6, -5.6, 5.6, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -5.6, 5.6, -5.6, 4.42, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -5.6, 4.42, -7.61, 4.42, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -7.61, 4.42, -7.61, -4.42, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -7.61, -4.42, -5.6, -4.42, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -5.6, -4.42, -5.6, -5.6, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -5.6, -5.6, -4.42, -5.6, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -4.15, -5.1, -5.1, -5.1, eTopOverlay, 0.15, False);
        CreateComponentTrack(NewPCBLibComp, -5.1, -5.1, -5.1, -4.15, eTopOverlay, 0.15, False);
        CreateComponentTrack(NewPCBLibComp, 4.15, -5.1, 5.1, -5.1, eTopOverlay, 0.15, False);
        CreateComponentTrack(NewPCBLibComp, 5.1, -5.1, 5.1, -4.15, eTopOverlay, 0.15, False);
        CreateComponentTrack(NewPCBLibComp, 4.15, 5.1, 5.1, 5.1, eTopOverlay, 0.15, False);
        CreateComponentTrack(NewPCBLibComp, 5.1, 5.1, 5.1, 4.15, eTopOverlay, 0.15, False);
        CreateComponentTrack(NewPCBLibComp, -4.15, 5.1, -5.1, 5.1, eTopOverlay, 0.15, False);
        CreateComponentTrack(NewPCBLibComp, -5.1, 5.1, -5.1, 4.15, eTopOverlay, 0.15, False);

        CurrentLib.RegisterComponent(NewPCBLibComp);
        CurrentLib.CurrentComponent := NewPcbLibComp;
    Finally
        PCBServer.PostProcess;
    End;

    CurrentLib.Board.ViewManager_FullUpdate;
    Client.SendMessage('PCB:Zoom', 'Action=All' , 255, Client.CurrentView)
End;

Procedure CreateALibrary;
Var
    View     : IServerDocumentView;
    Document : IServerDocument;

Begin
    If PCBServer = Nil Then
    Begin
        ShowMessage('No PCBServer present. This script inserts a footprint into an existing PCB Library that has the current focus.');
        Exit;
    End;

    CurrentLib := PcbServer.GetCurrentPCBLibrary;
    If CurrentLib = Nil Then
    Begin
        ShowMessage('You must have focus on a PCB Library in order for this script to run.');
        Exit;
    End;

    View := Client.GetCurrentView;
    Document := View.OwnerDocument;
    Document.Modified := True;

    CreateComponentQFP50P1290X1290X120_64L25M(0);

End;

End.
