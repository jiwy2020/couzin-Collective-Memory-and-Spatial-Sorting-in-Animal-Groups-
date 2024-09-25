function adj_matrix = calculate_adj_matrix(C, V, N, cos_half_alpha, ra)
    % 初始化邻接矩阵
    adj_matrix = zeros(N);

    for i = 1:N
        for j = 1:N
            if i ~= j
                % 计算相对位置向量
                relative_position = C(j, :) - C(i, :);

                % 计算距离和方向余弦
                distance = norm(relative_position);
                direction_cosine = dot(relative_position, V(i, :)) / distance;

                % 检查是否在感知锥形区域内
                if direction_cosine > cos_half_alpha && distance < ra
                    adj_matrix(i, j) = 1;
                end
            end
        end
    end

    % 将邻接矩阵变为对称矩阵
    adj_matrix = adj_matrix | adj_matrix';
end
