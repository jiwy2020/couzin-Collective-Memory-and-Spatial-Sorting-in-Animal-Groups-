clear; close; clc;
% 参数设置
N = 100;            % 个体数————10-100
dt = 0.1;           % 时间步长————0.1
steps = 5000;       % 迭代次数
rr = 1;             % 排斥半径————1
dro = 1.5;           % 对齐环范围————0-15    0~0.5：swarm    0.5~2.5：torus    2.5~6：dpg    6.5~15：hpg
dra = 15;           % 吸引环范围————0-15
alpha = 270 * pi / 180;         % 视野角度，°————200-360  最终为弧度单位
theta0 = 40;        % 旋转率，°/s————10-100
theta = theta0 * dt * pi / 180; % 旋转率，rad
s = 3;              % 速度speed————1-5

ro = rr + dro;
ra = ro + dra;

% 生成初始位置和方向
scale = 15; % 初始球体的直径
[C, V] = initialize_points(N, scale, alpha, ra);

% 初始化记录：群极化，群角动量，最大连通分量质心
pg_t = zeros(steps, 1);
mg_t = zeros(steps, 1);
cg_t = zeros(steps, 3);

% 计算cos(alpha/2)用于感知角的判断
cos_half_alpha = cos(alpha / 2);

for t = 1:steps
    % 整点花活
    % if (t > 10 && t < 550)
    %     dro = 2;
    %     ro = rr + dro;
    %     ra = ro + dra;
    % elseif (t >= 550 && t < 600)
    %     dro = 5;
    %     ro = rr + dro;
    %     ra = ro + dra;
    % elseif (t >= 600 && t < 650)
    %     dro = 12;
    %     ro = rr + dro;
    %     ra = ro + dra;
    % end


    % 计算新的速度
    V_new = update_directions(C, V, N, rr, ro, ra, theta, alpha);

    % 更新当前的速度和位置
    % V = V_new ./ vecnorm(V_new, 2, 2);
    V = V_new;
    C = C + V * dt * s;

    % 构建邻接矩阵，判断点是否在感知范围内（ra和alpha限制）
    adj_matrix = calculate_adj_matrix(C, V, N, cos_half_alpha, ra);

    % 寻找最大连通分量
    valid_points = find_largest_component(adj_matrix);

    % 重新计算质心，只考虑最大连通分量的点
    cg = mean(C(valid_points, :), 1);
    cg_t(t, :) = cg;

    % 计算群极化，只考虑最大连通分量的点
    pg = norm(sum(V(valid_points, :))) / sum(valid_points);
    pg_t(t) = pg;

    % 计算群角动量，只考虑有效点
    rc = C(valid_points, :) - cg;
    mg = norm(sum(cross(rc, V(valid_points, :)))) / sum(valid_points);
    mg_t(t) = mg;

    % 可视化
    arr_len = 1;
    ax_lim = 20;
    visualize_simulation(C, V * arr_len, t, [-ax_lim ax_lim], [-ax_lim ax_lim], [-ax_lim ax_lim], cg_t(1:t, :));
end