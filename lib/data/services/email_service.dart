class EmailService {
  /// Sends a welcome email to a newly registered user
  static Future<bool> sendWelcomeEmail({
    required String userEmail,
    required String userName,
  }) async {
    try {
      final emailTemplate = await _generateWelcomeEmailTemplate(
        userName: userName,
        userEmail: userEmail,
      );

      // For now, we'll simulate sending the email
      // In production, you would integrate with an email service like:
      // - EmailJS
      // - SendGrid
      // - Firebase Functions with Nodemailer
      // - AWS SES
      
      print('=== WELCOME EMAIL SENT ===');
      print('To: $userEmail');
      print('Subject: Welcome to Gaiosophy - Your Plant Wisdom Journey Begins! 🌿');
      print('Email Template Length: ${emailTemplate.length} characters');
      print('==========================');
      
      // For demonstration, let's simulate a successful email send
      await Future<void>.delayed(const Duration(seconds: 1));
      return true;
      
    } catch (e) {
      print('Error sending welcome email: $e');
      return false;
    }
  }

  /// Generates the HTML template for the welcome email (public for preview)
  static Future<String> generateWelcomeEmailTemplate({
    required String userName,
    required String userEmail,
  }) async {
    return _generateWelcomeEmailTemplate(
      userName: userName,
      userEmail: userEmail,
    );
  }

  /// Generates the HTML template for the welcome email
  static Future<String> _generateWelcomeEmailTemplate({
    required String userName,
    required String userEmail,
  }) async {
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Gaiosophy</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto+Slab:wght@300;400;500;600;700&family=Public+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Public Sans', Arial, sans-serif;
            line-height: 1.6;
            color: #1A1612;
            background-color: #FCF9F2;
        }
        
        .email-container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #FCF9F2;
            padding: 0;
        }
        
        .header {
            background: linear-gradient(135deg, #8B4513 0%, #8B6B47 100%);
            color: white;
            text-align: center;
            padding: 40px 20px;
            position: relative;
            overflow: hidden;
        }
        
        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><path d="M20 20c20 0 20 20 40 20s20-20 40-20v60c-20 0-20 20-40 20s-20-20-40-20z" fill="rgba(255,255,255,0.1)"/></svg>') repeat;
            opacity: 0.1;
        }
        
        .logo {
            font-family: 'Roboto Slab', serif;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
        }
        
        .logo::before {
            content: '🌿';
            margin-right: 8px;
        }
        
        .tagline {
            font-size: 16px;
            font-weight: 300;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }
        
        .content {
            padding: 40px 30px;
            background-color: white;
            margin: 0 20px;
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(139, 69, 19, 0.1);
            margin-top: -20px;
            position: relative;
            z-index: 2;
        }
        
        .welcome-title {
            font-family: 'Roboto Slab', serif;
            font-size: 28px;
            font-weight: 600;
            color: #1A1612;
            text-align: center;
            margin-bottom: 20px;
        }
        
        .welcome-message {
            font-size: 16px;
            color: #5A4E3C;
            margin-bottom: 30px;
            text-align: center;
            line-height: 1.8;
        }
        
        .features-section {
            margin: 40px 0;
        }
        
        .features-title {
            font-family: 'Roboto Slab', serif;
            font-size: 22px;
            font-weight: 600;
            color: #1A1612;
            text-align: center;
            margin-bottom: 30px;
        }
        
        .feature {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            padding: 16px;
            background-color: #F2E9D7;
            border-radius: 12px;
            border-left: 4px solid #8B6B47;
        }
        
        .feature-icon {
            font-size: 24px;
            margin-right: 16px;
            width: 40px;
            text-align: center;
        }
        
        .feature-content h3 {
            font-family: 'Roboto Slab', serif;
            font-size: 16px;
            font-weight: 600;
            color: #1A1612;
            margin-bottom: 4px;
        }
        
        .feature-content p {
            font-size: 14px;
            color: #5A4E3C;
            line-height: 1.5;
        }
        
        .cta-section {
            text-align: center;
            margin: 40px 0;
        }
        
        .cta-button {
            display: inline-block;
            background: linear-gradient(135deg, #8B4513 0%, #8B6B47 100%);
            color: white;
            padding: 16px 32px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            transition: transform 0.2s ease;
            box-shadow: 0 4px 16px rgba(139, 69, 19, 0.3);
        }
        
        .cta-button:hover {
            transform: translateY(-2px);
        }
        
        .quote-section {
            background: linear-gradient(135deg, #F2E9D7 0%, #E5D5C0 100%);
            padding: 30px;
            border-radius: 16px;
            margin: 30px 0;
            text-align: center;
            border: 1px solid #E5D5C0;
        }
        
        .quote {
            font-family: 'Roboto Slab', serif;
            font-size: 18px;
            font-style: italic;
            color: #1A1612;
            margin-bottom: 10px;
            line-height: 1.6;
        }
        
        .quote-author {
            font-size: 14px;
            color: #8B6B47;
            font-weight: 500;
        }
        
        .footer {
            background-color: #1A1612;
            color: white;
            text-align: center;
            padding: 30px 20px;
            margin-top: 40px;
        }
        
        .footer-content {
            max-width: 500px;
            margin: 0 auto;
        }
        
        .footer h3 {
            font-family: 'Roboto Slab', serif;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .footer p {
            font-size: 14px;
            opacity: 0.8;
            margin-bottom: 20px;
        }
        
        .social-links {
            margin-bottom: 20px;
        }
        
        .social-link {
            display: inline-block;
            margin: 0 10px;
            color: #8B6B47;
            text-decoration: none;
            font-size: 20px;
        }
        
        .footer-note {
            font-size: 12px;
            opacity: 0.6;
            border-top: 1px solid #333;
            padding-top: 20px;
        }
        
        .user-info {
            background: linear-gradient(135deg, #8B6B47 0%, #8B4513 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            margin: 20px 0;
            text-align: center;
        }
        
        .user-info h3 {
            font-family: 'Roboto Slab', serif;
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 8px;
        }
        
        .user-info p {
            opacity: 0.9;
            font-size: 14px;
        }
        
        @media (max-width: 600px) {
            .content {
                margin: 0 10px;
                padding: 30px 20px;
                margin-top: -20px;
            }
            
            .welcome-title {
                font-size: 24px;
            }
            
            .feature {
                flex-direction: column;
                text-align: center;
            }
            
            .feature-icon {
                margin-right: 0;
                margin-bottom: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="email-container">
        <!-- Header -->
        <div class="header">
            <div class="logo">Gaiosophy</div>
            <div class="tagline">Ancient Plant Wisdom for Modern Life</div>
        </div>
        
        <!-- Main Content -->
        <div class="content">
            <h1 class="welcome-title">Welcome to Your Plant Wisdom Journey! 🌱</h1>
            
            <div class="user-info">
                <h3>Hello, $userName!</h3>
                <p>Thank you for joining our community of plant wisdom seekers</p>
            </div>
            
            <p class="welcome-message">
                We're thrilled to have you join our community of plant wisdom seekers! 
                Gaiosophy is your gateway to discovering the ancient secrets of plants, 
                from their magical properties to their healing powers.
            </p>
            
            <!-- Features Section -->
            <div class="features-section">
                <h2 class="features-title">What Awaits You</h2>
                
                <div class="feature">
                    <div class="feature-icon">🌿</div>
                    <div class="feature-content">
                        <h3>Plant Allies Guide</h3>
                        <p>Discover detailed profiles of magical and medicinal plants, complete with harvesting guides and folklore</p>
                    </div>
                </div>
                
                <div class="feature">
                    <div class="feature-icon">🔮</div>
                    <div class="feature-content">
                        <h3>Magical Rituals</h3>
                        <p>Learn time-honored rituals and spellwork using the power of plants and natural elements</p>
                    </div>
                </div>
                
                <div class="feature">
                    <div class="feature-icon">🌙</div>
                    <div class="feature-content">
                        <h3>Folk Medicine</h3>
                        <p>Explore traditional healing practices and herbal remedies passed down through generations</p>
                    </div>
                </div>
                
                <div class="feature">
                    <div class="feature-icon">📚</div>
                    <div class="feature-content">
                        <h3>Ancient Wisdom</h3>
                        <p>Access folklore, myths, and cultural stories that reveal the spiritual significance of plants</p>
                    </div>
                </div>
            </div>
            
            <!-- Inspirational Quote -->
            <div class="quote-section">
                <div class="quote">
                    "In every walk with nature, one receives far more than they seek. 
                    The earth speaks in whispers through every leaf, every flower, every root."
                </div>
                <div class="quote-author">— Ancient Plant Wisdom</div>
            </div>
            
            <!-- Call to Action -->
            <div class="cta-section">
                <a href="https://your-app-url.com" class="cta-button">
                    🌱 Begin Your Journey
                </a>
            </div>
            
            <p class="welcome-message">
                Ready to unlock the secrets of the plant kingdom? Your journey into ancient wisdom starts now.
                <br><br>
                <em>May your path be guided by the whispers of the earth.</em>
            </p>
        </div>
        
        <!-- Footer -->
        <div class="footer">
            <div class="footer-content">
                <h3>🌿 Gaiosophy</h3>
                <p>Connecting you with the ancient wisdom of plants</p>
                
                <div class="social-links">
                    <a href="#" class="social-link">🌍</a>
                    <a href="#" class="social-link">📱</a>
                    <a href="#" class="social-link">💌</a>
                </div>
                
                <div class="footer-note">
                    You're receiving this email because you signed up for Gaiosophy.<br>
                    If you no longer wish to receive emails, you can unsubscribe at any time.
                </div>
            </div>
        </div>
    </div>
</body>
</html>
    ''';
  }
}
