#!/bin/bash

# Tạo swap trên Ubuntu
echo "Nhập dung lượng swap bạn muốn tạo (đơn vị: GB):"
read swap_size

# Chuyển đổi dung lượng từ GB sang MB
swap_size_mb=$((swap_size * 1024))

# Tên file swap
swap_file="/swapfile"

# Kiểm tra nếu swapfile đã tồn tại
if [ -f $swap_file ]; then
    echo "Swapfile đã tồn tại. Bạn có muốn ghi đè? (y/n):"
    read overwrite
    if [ "$overwrite" != "y" ]; then
        echo "Hủy thao tác."
        exit 1
    fi
    sudo swapoff $swap_file
    sudo rm $swap_file
fi

# Tạo file swap
echo "Đang tạo file swap..."
sudo fallocate -l "${swap_size_mb}M" $swap_file

# Đặt quyền cho file swap
echo "Đặt quyền cho file swap..."
sudo chmod 600 $swap_file

# Định dạng file swap
echo "Định dạng file swap..."
sudo mkswap $swap_file

# Kích hoạt swap
echo "Kích hoạt swap..."
sudo swapon $swap_file

# Thêm vào fstab để kích hoạt swap khi khởi động
if ! grep -q "$swap_file" /etc/fstab; then
    echo "Thêm swap vào /etc/fstab..."
    echo "$swap_file none swap sw 0 0" | sudo tee -a /etc/fstab > /dev/null
fi

# Kiểm tra trạng thái swap
echo "Swap đã được tạo với dung lượng $swap_size GB."
sudo swapon --show
