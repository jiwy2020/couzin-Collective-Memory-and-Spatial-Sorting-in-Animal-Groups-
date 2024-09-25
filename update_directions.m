function V_new = update_directions(C, V, N, rr, ro, ra, theta, alpha)
    % 计算每个个体的新方向
    % theta单位：弧度
    % alpha单位：弧度

    % 初始化新的方向矩阵
    V_new = zeros(N, 3);

    % 预计算感知角度的cos值
    cos_half_alpha = cos(alpha / 2);

    % 对每个个体进行更新
    for i = 1:N
        % 初始化三种方向向量
        dr = [0, 0, 0];  % 排斥方向
        do = [0, 0, 0];  % 对齐方向
        da = [0, 0, 0];  % 吸引方向
        di = [0, 0, 0];  % 最终方向

        % 初始化累计向量
        nr = 0;  % 排斥范围内的邻居数
        no = 0;  % 对齐范围内的邻居数
        na = 0;  % 吸引范围内的邻居数

        % 遍历其他个体，计算每个个体的方向更新
        for j = 1:N
            if i == j
                continue; % 不与自己计算
            end

            % 计算相对位置信息
            distance = C(j, :) - C(i, :);
            radius = norm(distance);
            direction = distance ./ radius;

            % 计算与视野方向的余弦值，判断是否在感知范围内
            cos_angle = dot(V(i, :), direction);

            % 如果在感知角alpha内，才继续判断距离
            if cos_angle > cos_half_alpha
                if radius < rr
                    dr = dr - direction; % 排斥
                    nr = nr + 1;
                elseif radius < ro
                    do = do + V(j, :); % 对齐
                    no = no + 1;
                elseif radius < ra
                    da = da + direction; % 吸引
                    na = na + 1;
                end
            end
        end

        % 判断并计算最终方向di
        if nr > 0
            di = dr;
        elseif nr == 0
            if na ~= 0 && no ~= 0
                di = 0.5 * (do + da);
            elseif na == 0
                di = do;
            elseif no == 0
                di = da;
            end
        end

        % 如果没有邻居或方向为零，则保持原有方向
        if norm(di) == 0 || nr + no + na == 0
            di = V(i, :);
        end

        % 对方向di归一化
        di = di / norm(di);

        % 计算当前方向与新方向的夹角
        dot_product = dot(V(i, :), di); % 模长都是1所以不用除东西
        angle_between = acos(dot_product); % 夹角（弧度）

        % 如果夹角大于theta，则旋转theta角度
        if angle_between > theta
            % 计算旋转轴
            rotation_axis = cross(V(i, :), di); % 一个向量，垂直于两向量所在平面
            rotation_axis = rotation_axis / norm(rotation_axis);

            % 使用Rodrigues公式进行旋转
            R = axang2rotm([rotation_axis, theta]); % 旋转矩阵
            di = (R * V(i, :)')'; % 旋转后的方向
            di = di / norm(di);
        end

        % 更新个体的新方向
        V_new(i, :) = di;
    end
end
