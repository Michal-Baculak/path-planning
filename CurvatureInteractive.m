%generate random points to be connected by a spline
n = 10

x = rand(1,n)
y = rand(1,n)
t = linspace(0,1,n);

%generate the spline
global sp_x sp_y dsp_x dsp_y ddsp_x ddsp_y

sp_x = spline(t, x);
sp_y = spline(t, y);

dsp_x = fnder(sp_x);
dsp_y = fnder(sp_y);
ddsp_x = fnder(dsp_x);
ddsp_y = fnder(dsp_y);

t_plot = linspace(0,1,1000);
h_fig = figure(1);
hPlot = plot(ppval(sp_x,t_plot), ppval(sp_y, t_plot));

title("Spline osculating circle Demo");
axis equal;
hold on;

%get user input

%setup slider
hSlider = uicontrol("Style","slider","Min",0,"Max",1,"Position",[70,10,450,20]) %,"Callback",@slider_callback 
addlistener(hSlider, "Value", "PostSet", @slider_callback)

function slider_callback(hObject, eventData)
    global sp_x sp_y dsp_x dsp_y h_arr ddsp_x ddsp_y
    persistent arr_x arr_y arr_u arr_v h_osc_circ

    t_s = eventData.AffectedObject.Value
    %evaluate derivative at that point
    arr_x = ppval(sp_x, t_s);
    arr_y = ppval(sp_y,t_s);
    arr_u = ppval(dsp_x, t_s);
    arr_v = ppval(dsp_y, t_s);

    %normalize cause the scale is insane
    norm = sqrt(arr_u^2 + arr_v^2);
    arr_u = arr_u/norm * 0.1;
    arr_v = arr_v/norm * 0.1;

    %draw an arrow (tangent)
    if(~isempty(h_arr) && isvalid(h_arr))
        set(h_arr, "XData", arr_x, "YData", arr_y, "UData", arr_u, "VData", arr_v);        
    else
        h_arr = quiver(arr_x, arr_y, arr_u, arr_v, "LineWidth", 2);
    end

    %determine normal vector from 2nd derivative of spline

    %-------------Does not work, reason might be that spline does not have
    %normal derivative (normal meaning equal to one)
    % n_arr_u = ppval(ddsp_x, t_s);
    % n_arr_v = ppval(ddsp_y, t_s);
    % 
    % norm2 = sqrt(n_arr_u^2 + n_arr_v^2);
    % n_arr_u = n_arr_u/norm2 * 0.1;
    % n_arr_v = n_arr_v/norm2 * 0.1;
    
    %https://en.wikipedia.org/wiki/Osculating_circle
    k = (ppval(dsp_x, t_s)*ppval(ddsp_y, t_s) - ppval(ddsp_x,t_s)*ppval(dsp_y,t_s))...
        /(sqrt(ppval(dsp_x,t_s)^2 + ppval(dsp_y,t_s)^2)^3)
    r = abs(1/k);
    abs_dsp = sqrt(ppval(dsp_x, t_s)^2 + ppval(dsp_y,t_s)^2);
    q = [ppval(sp_x,t_s); ppval(sp_y,t_s)] + 1/(k*abs_dsp)*[-ppval(dsp_y, t_s); ppval(dsp_x,t_s)];
    if(~isempty(h_osc_circ))
        delete(h_osc_circ)
    end
    h_osc_circ = rectangle('Position',[q(1) - r, q(2) - r, 2*r, 2*r], 'Curvature', [1 1]);


end