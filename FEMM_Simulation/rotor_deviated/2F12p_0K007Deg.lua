function modulo(A,B) 
C=0;zahler=0
for i=0,A,B do
zahler = zahler + 1;C=i;
end
return (zahler-1), (A-C) -- ganzzahliges Divisonsergebnis, Rest
end

-- Draw plates
function draw_plates(xzero,middle,right)


-- middle = (right+xzero)/2
top = 2 * empty + 2 * mh + 2 * platethickness + ag;


-- Space above and underneath
mi_addnode(xzero,0);
mi_addnode(xzero,top);
mi_addnode(right,top);
mi_addnode(right,0);

mi_addsegment(xzero,0,xzero,top);
mi_addsegment(xzero,top,right,top);
mi_addsegment(right,top,right,0);
mi_addsegment(right,0,xzero,0);

mi_addblocklabel(middle, top/2);
mi_selectlabel(middle,top/2);
mi_setblockprop("Air",0,meshsize,"",0,xzero,0)


mi_addblocklabel(middle,empty/2);
mi_addblocklabel(middle,empty/2);
mi_selectlabel(middle,empty/2);
mi_setblockprop("Air",0,meshsize,"",0,xzero,0)

mi_addblocklabel(middle,top-empty/2);
mi_addblocklabel(middle,top-empty/2);
mi_selectlabel(middle,top-empty/2);
mi_setblockprop("Air",0,meshsize,"",0,xzero,0)

-- Lower Plate --
mi_addnode(xzero,empty);
mi_addnode(right,empty);
mi_addnode(right,plate1top);
mi_addnode(xzero,plate1top);

mi_addsegment(xzero,empty,right,empty);
mi_addsegment(xzero,plate1top,right,plate1top);
mi_setblockprop("",0,meshsize,"",0,xzero,0)

mi_addblocklabel(middle,(empty+plate1top)/2);
mi_addblocklabel(middle,(empty+plate1top)/2);
mi_selectlabel(middle,(empty+plate1top/2));
mi_setblockprop("1010 Steel",0,meshsize,"",0,0,0)
-- Top plate
plate2top = top-empty;
plate2bot=plate2top-platethickness

mi_addnode(xzero,plate2bot);
mi_addnode(right,plate2bot);
mi_addnode(right,plate2top);
mi_addnode(xzero,plate2top);

mi_addsegment(left,plate2bot,right,plate2bot);
mi_addsegment(left,plate2top,right,plate2top);

mi_addblocklabel(middle,(plate2bot+plate2top)/2);
mi_addblocklabel(middle,(plate2bot+plate2top)/2);
mi_selectlabel(middle,(plate2bot+plate2top)/2);
mi_setblockprop("1010 Steel",0,meshsize,"",0,0,0);
end

-- Draw Magnet


function draw_magnet(mag1left,mag1right,mag1top,mag1bot,orientation)

mi_addnode(mag1left,mag1bot);
mi_addnode(mag1left,mag1top);
mi_addnode(mag1right,mag1top);
mi_addnode(mag1right,mag1bot);

mi_addsegment(mag1left,mag1bot,mag1left,mag1top);
mi_addsegment(mag1left,mag1top,mag1right,mag1top);
mi_addsegment(mag1right,mag1top,mag1right,mag1bot);

mi_addblocklabel((mag1left+mag1right)/2,(mag1top+mag1bot)/2);
mi_addblocklabel((mag1left+mag1right)/2,(mag1top+mag1bot)/2);
mi_selectlabel((mag1left+mag1right)/2,(mag1top+mag1bot)/2);
mi_setblockprop(Magnet,0,meshsize,"",orientation,0,0);
print("Magnet left,right,top,bot,orin: ",mag1left,mag1right,mag1top,mag1bot,orientation)
end


-- Coil
function draw_coil(x1,y1,x2,y2,x3,y3,x4,y4,turns,cn)
print("Coil x,y: ",x1,y1)
print("Coil x,y: ",x2,y2)
print("Coil x,y: ",x3,y3)
print("Coil x,y: ",x4,y4)
mi_clearselected()
mi_addnode(x1,y1);
mi_addnode(x2,y2);
mi_addnode(x3,y3);
mi_addnode(x4,y4);
mi_addsegment(x1,y1,x2,y2);
mi_addsegment(x2,y2,x3,y3);
mi_addsegment(x3,y3,x4,y4);
mi_addsegment(x4,y4,x1,y1);
mi_selectrectangle(x1,y1,x3,y3,4)
mi_setgroup(1)
mi_addblocklabel((x1+x3)/2,(y1+y3)/2);
mi_selectlabel((x1+x3)/2,(y1+y3)/2);
-- mi_setblockprop("blockname", automesh, meshsize, "incircuit", magdirection,group, turns)
mi_setblockprop(Coil, automesh, meshsize, cn, coil_magdirection,1, turns)

end

function draw_coil_rotbas(d1,d2,turns,cn)

r1=sqrt(d1^2+(winding_thickness/2)^2);r4=r1;
print("r1: ",r1)
a1=asin((winding_thickness/2)/r1);a4=-a1;
r2=sqrt(d2^2+(winding_thickness/2)^2);r3=r2;
a2=asin((winding_thickness/2)/r2);a3=-a2;

x1=rotbase_x+cos(PI+rotation-a1)*r1
print("cos(PI-a1)*r1= ",cos(PI-a1)*r1)
y1=rotbase_y+sin(PI+rotation-a1)*r1
x2=rotbase_x+cos(PI+rotation-a2)*r2
y2=rotbase_y+sin(PI+rotation-a2)*r2
x3=rotbase_x+cos(PI+rotation-a3)*r3
y3=rotbase_y+sin(PI+rotation-a3)*r3
x4=rotbase_x+cos(PI+rotation-a4)*r4
y4=rotbase_y+sin(PI+rotation-a4)*r4

draw_coil(x1,y1,x2,y2,x3,y3,x4,y4,turns,cn)

end

function points_twoli(d1,d2)

r1=sqrt(d1^2+(winding_thickness/2)^2);r4=r1;
a1=asin((winding_thickness/2)/r1);a4=-a1;
r2=sqrt(d2^2+(winding_thickness/2)^2);r3=r2;
a2=asin((winding_thickness/2)/r2);a3=-a2;

x1=rotbase_x+cos(PI+rotation-a1)*r1
y1=rotbase_y+sin(PI+rotation-a1)*r1
x2=rotbase_x+cos(PI+rotation-a2)*r2
y2=rotbase_y+sin(PI+rotation-a2)*r2
x3=rotbase_x+cos(PI+rotation-a3)*r3
y3=rotbase_y+sin(PI+rotation-a3)*r3
x4=rotbase_x+cos(PI+rotation-a4)*r4
y4=rotbase_y+sin(PI+rotation-a4)*r4

mi_clearselected()
mi_addnode(x1,y1);
mi_addnode(x2,y2);
mi_addnode(x3,y3);
mi_addnode(x4,y4);

end


function calc_twoli(d1,d2)

r1=sqrt(d1^2+(winding_thickness/2)^2);r4=r1;
a1=asin((winding_thickness/2)/r1);a4=-a1;
r2=sqrt(d2^2+(winding_thickness/2)^2);r3=r2;
a2=asin((winding_thickness/2)/r2);a3=-a2;

x1=rotbase_x+cos(PI+rotation-a1)*r1
y1=rotbase_y+sin(PI+rotation-a1)*r1
x2=rotbase_x+cos(PI+rotation-a2)*r2
y2=rotbase_y+sin(PI+rotation-a2)*r2
x3=rotbase_x+cos(PI+rotation-a3)*r3
y3=rotbase_y+sin(PI+rotation-a3)*r3
x4=rotbase_x+cos(PI+rotation-a4)*r4
y4=rotbase_y+sin(PI+rotation-a4)*r4

mo_clearcontour();
mo_selectpoint(x4,y4)
mo_selectpoint(x3,y3)
result= result .. ";" .. mo_lineintegral(0)
mo_clearcontour();
mo_selectpoint(x1,y1)
mo_selectpoint(x2,y2)
result= result .. ";" .. mo_lineintegral(0)

end


-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++ Ab hier gehts los +++
-- +++++ V2: Drehpunkt der Spulen ist fixiert +++ 
-- ++++++++++++++++++++++++++

sim_name = "2F12P_V2_0K007Deg"
showconsole();
print("Draw Generator")
pi=PI

result="i;x;A; B1; B2; Sig; E; H1; H2; Je; Js; Mu1; Mu2; Pe; Ph;;mu;mo;r1u;r1o;r2u;r2o;r3u;r3o;l1u;l1o;l2u;l2o;l3u;l3o;"
fp=openfile(sim_name .. "_results.txt","a")
write(fp,result,"\n")
closefile(fp);


for i=90,90+360/12*2,1
-- for i=90,120,10
do


cwt=88,6627260013119  ;Umfang=9*cwt
-- x=1.2*pi/2*Umfang/(2*pi)
x=i * (Umfang/360)
print("X= ",x)

platethickness=6;
empty =1;
-- Magnet
mw=50,3286  --magwith
mh=20 --magheight
mg=16,1683 --magspace
ag=12+4 --airgap
mwt=mw+mg
meshsize=0.4;
automesh=1;
Magnet="Ceramic 8";

-- Coil
Coil="1.6mm"
windingwith=22,8523489932886 ;ww=windingwith;
windinginnerwith=40,9446051959428 ;wiw=windinginnerwith;
windingspace=1/2*2,01342281879195 ;ws=windingspace;
gap_coil_magnet=2
winding_thickness=12;wt=winding_thickness;
coil_magdirection=90;
turnsA=1000;

rotation=0.007

newdocument(0);

mi_getmaterial("Air");
mi_getmaterial("1010 Steel");
mi_getmaterial(Magnet);
mi_getmaterial(Coil);

polenr, remainder =modulo(x,mwt)
print("remainder: ",remainder)

quotient, remainder_b = modulo(polenr,2.0)
if (remainder_b < 0.1) then  --even
    polarity=1
else
    polarity= -1        -- odd
end


ax=x- remainder -2* mwt - mg/2
zx=ax + 5*mwt 

plate1top = empty + platethickness;
draw_plates(ax,x,zx)


m1x0 = ax + mg/2
m1x0t = m1x0

my0 = plate1top
my1 = my0 + mh
my2 = my1 + ag
my3 = my2 + mh


print("Magnetpair 1")
--draw_magnet(mag1left,mag1right,mag1top,mag1bot,orientation)
-- draw magnet left bottom
draw_magnet(m1x0t,m1x0+mw,my1,my0,polarity * 90)
-- draw magnet left top
draw_magnet(m1x0t,m1x0+mw,my2,my3,polarity * 90)

print("Magnetpair 2")
m2x0 = m1x0 + mwt
m2x1 = m2x0 + mw
draw_magnet(m2x0,m2x1,my1,my0,polarity * -90)
draw_magnet(m2x0,m2x1,my2,my3,polarity * -90)

print("Magnetpair 3")
m3x0 = m2x0 + mwt
m3x1 = m3x0 + mw
draw_magnet(m3x0,m3x1,my1,my0,polarity * 90)
draw_magnet(m3x0,m3x1,my2,my3,polarity * 90)

print("Magnetpair 4")
m4x0 = m3x0 + mwt
m4x1 = m4x0 + mw
draw_magnet(m4x0,m4x1,my1,my0,polarity * -90)
draw_magnet(m4x0,m4x1,my2,my3,polarity * -90)

print("Magnetpair 5")
m5x0 = m4x0 + mwt
m5x1 = m5x0 + mw
draw_magnet(m5x0,m5x1,my1,my0,polarity * 90)
draw_magnet(m5x0,m5x1,my2,my3,polarity * 90)


-- Coil Circuit 
mi_addcircprop("H", 0.0, 1) --1=Series
mi_addcircprop("N", 0.0, 1) --1=Series

-- Draw Coils
rotbase_x=x+Umfang/4
rotbase_y=(my2+my1)/2
print("Rotbase_x ",rotbase_x)
print("Rotbase_y ",rotbase_y)

-- Coilleg 1
d1=rotbase_x-(x+wiw/2+ww)
d2=rotbase_x-(x+wiw/2)
draw_coil_rotbas(d1,d2,turnsA,"H")

-- Coilleg 2
d1=rotbase_x-(x-wiw/2-ww)
d2=rotbase_x-(x-wiw/2)
draw_coil_rotbas(d1,d2,-turnsA,"H")

-- Coilleg 1 extra
d1=rotbase_x-(x+wiw/2+ww+2*ws+ww)
d2=rotbase_x-(x+wiw/2+ww+2*ws)
draw_coil_rotbas(d1,d2,-turnsA,"N")

-- Coilleg 2 extra
d1=rotbase_x-(x-wiw/2-ww-2*ws-ww)
d2=rotbase_x-(x-wiw/2-ww-2*ws)
draw_coil_rotbas(d1,d2,turnsA,"N")


mi_clearselected()
-- mi_selectgroup(1)
-- mi_moverotate(rotbase_x,rotbase_y,rotation,4);

-- Make Points for Lineintegral
-- Lineintegral m
md1=rotbase_x-(x+wiw/2)
md2=rotbase_x-(x-wiw/2)
points_twoli(md1,md2)

-- Lineintegral r1
r1d1=rotbase_x-(x+wiw/2+ww/3)
r1d2=rotbase_x-(x+wiw/2)
points_twoli(r1d1,r1d2)
-- Lineintegral r2
r2d1=rotbase_x-(x+wiw/2+ww*2/3)
r2d2=rotbase_x-(x+wiw/2+ww*1/3)
points_twoli(r2d1,r2d2)
-- Lineintegral r3
r3d1=rotbase_x-(x+wiw/2+ww)
r3d2=rotbase_x-(x+wiw/2+ww*2/3)
points_twoli(r3d1,r3d2)

-- Lineintegral l1
l1d1=rotbase_x-(x-wiw/2)
l1d2=rotbase_x-(x-wiw/2-ww*1/3)
points_twoli(l1d1,l1d2)
-- Lineintegral l2
l2d1=rotbase_x-(x-wiw/2-ww*1/3)
l2d2=rotbase_x-(x-wiw/2-ww*2/3)
points_twoli(l2d1,l2d2)
-- Lineintegral l3
l3d1=rotbase_x-(x-wiw/2-ww*2/3)
l3d2=rotbase_x-(x-wiw/2-ww)
points_twoli(l3d1,l3d2)



mi_zoomnatural();


-- mi_clearselected;
print("Simulate");
a=sim_name .. i
mi_saveas(a..".fem")
mi_savebitmap(a..".jpg")


if 1 then

mi_analyze(1);
mi_loadsolution();
mo_showdensityplot(1,0,1.5,0.000001,"bmag")
print("X: ",x);
print("Y: ",(my1+my2)/2);
A, B1, B2, Sig, E, H1, H2, Je, Js, Mu1, Mu2, Pe, Ph = mo_getpointvalues(x,(my1+my2)/2)
result=i ..";" .. x  .. ";" .. A  .. ";" ..   B1  .. ";" ..   B2  .. ";" ..   Sig  .. ";" ..   E  .. ";" ..   H1  .. ";" ..   H2  .. ";" ..   Je  .. ";" ..   Js  .. ";" ..   Mu1  .. ";" ..   Mu2  .. ";" ..   Pe  .. ";" ..   Ph  .. ";"


-- Calc Lineintegral 
calc_twoli(md1,md2)
calc_twoli(r1d1,r1d2)
calc_twoli(r2d1,r2d2)
calc_twoli(r3d1,r3d2)
calc_twoli(l1d1,l1d2)
calc_twoli(l2d1,l2d2)
calc_twoli(l3d1,l3d2)


mo_savebitmap(sim_name .."_dp_".. i ..".jpg")

fp=openfile(sim_name .. "_results.txt","a")
write(fp,result,"\n")
closefile(fp);


mo_close()
end

mi_close()
end
