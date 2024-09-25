function [C, V] = initialize_points(N, scale, alpha, ra)
    % 初始化点的位置和方向，并确保每个个体至少能检测到一个邻居
    % alpha单位：弧度

    % 设置球体的半径
    radius = scale / 2;
    
    % 将alpha角度转化为方向余弦的阈值
    cos_half_alpha = cos(alpha / 2);
    
    % 初始化位置和方向
    C = zeros(N, 3);
    V = zeros(N, 3);

    % 生成第一个点的位置和方向（不需要检测邻居）
    r = rand().^(1/3) * radius; % 极径
    theta = rand() * 2 * pi; % x-y平面上的角度
    phi = acos(2 * rand() - 1); % 与z轴夹角
    x = r * sin(phi) * cos(theta);
    y = r * sin(phi) * sin(theta);
    z = r * cos(phi);
    C(1, :) = [x, y, z];

    v = randn(1, 3);
    V(1, :) = v ./ norm(v); % 要归一化

    % 生成其他的点
    for i = 2:N
        detected = false;
        
        % 不断生成直到至少检测到一个邻居
        while ~detected
            % 生成随机位置
            r = rand().^(1/3) * radius;
            theta = rand() * 2 * pi;
            phi = acos(2 * rand() - 1);
            x = r * sin(phi) * cos(theta);
            y = r * sin(phi) * sin(theta);
            z = r * cos(phi);
            C(i, :) = [x, y, z];

            % 生成随机方向
            v = randn(1, 3);
            V(i, :) = v ./ norm(v);

            % 检测其他点是否在感知锥形区域内
            for j = 1:i-1
                % 计算相对位置向量
                relative_position = C(j, :) - C(i, :);
                
                % 计算距离和方向余弦
                distance = norm(relative_position);
                direction_cosine = dot(relative_position, V(i, :)) / distance; % 速度归一化了所以省去模
                
                % 检查是否在感知锥形区域内
                if direction_cosine > cos_half_alpha && distance < ra
                    detected = true;
                    break;
                end
            end
        end
    end

    % 计算等价类
    % 这里使用邻接矩阵表示每个个体之间的可达性
    adj_matrix = calculate_adj_matrix(C, V, N, cos_half_alpha, ra);

    % 使用等价类计算群体分裂
    % 使用连通分量来找到等价类
    G = graph(adj_matrix);
    components = conncomp(G);
    fprintf('初始化位置和方向，分成: %d 块', max(components));
end
