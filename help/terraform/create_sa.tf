# --- 3. Сервисный аккаунт для группы ВМ ---
    31 resource "yandex_iam_service_account" "ig_sa" {
    32   name        = "lamp-ig-sa"
    33   description = "Service account for the LAMP instance group"
    34 }
    35
    36 # Назначаем роль editor сервисному аккаунту, чтобы он мог управлять ресурсами
    37 resource "yandex_resourcemanager_folder_iam_binding" "editor" {
    38   folder_id = var.yc_folder_id
    39   role      = "editor"
    40   members = [
    41     "serviceAccount:${yandex_iam_service_account.ig_sa.id}",
    42   ]
    43 }
