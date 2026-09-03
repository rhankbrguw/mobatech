package constants

const (
	RegexEmailSyntax = `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`
	RegexName        = `^[a-zA-ZÀ-ÿ\s\.\'\,\\-]+$`
	RegexPhone       = `^(\+62|62|0)8[1-9][0-9]{7,11}$`

	MinNameLength     = 2
	MaxNameLength     = 100
	MinPasswordLength = 8
	MaxPasswordLength = 64
	MinPhoneLength    = 9
	MaxPhoneLength    = 15

	MsgEmailRequired       = "Email wajib diisi."
	MsgEmailInvalid        = "Format email tidak valid (contoh: nama@gmail.com)."
	MsgEmailDomainInvalid  = "Gunakan provider email resmi (Gmail, Yahoo, Outlook, iCloud, atau institusi resmi)."
	MsgEmailTypoDetected   = "Domain email terdeteksi salah ketik. Periksa kembali akhiran email Anda."
	MsgNameRequired        = "Nama lengkap wajib diisi."
	MsgNameInvalidChars    = "Nama hanya boleh mengandung huruf, spasi, titik, tanda petik, atau tanda hubung (tanpa angka)."
	MsgNameLengthInvalid   = "Nama harus memiliki panjang antara 2 hingga 100 karakter."
	MsgPhoneRequired       = "Nomor telepon wajib diisi."
	MsgPhoneInvalidFormat  = "Nomor HP harus berupa angka Indonesia valid (diawali 08, 628, atau +628) dengan panjang 10-14 digit."
	MsgPasswordRequired    = "Kata sandi wajib diisi."
	MsgPasswordWeak        = "Kata sandi minimal 8 karakter dengan kombinasi huruf besar, huruf kecil, dan angka."
)
