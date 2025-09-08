import 'dart:convert';
import 'package:http/http.dart' as http;

/// Email service using EmailJS for actual email delivery
class EmailServiceEmailJS {
  // EmailJS configuration - You need to set these up at https://www.emailjs.com/
  static const String _serviceId = 'YOUR_SERVICE_ID'; // Get from EmailJS dashboard
  static const String _templateId = 'YOUR_TEMPLATE_ID'; // Get from EmailJS dashboard  
  static const String _publicKey = 'YOUR_PUBLIC_KEY'; // Get from EmailJS dashboard
  static const String _emailJSUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  /// Sends a welcome email using EmailJS
  static Future<bool> sendWelcomeEmail({
    required String userEmail,
    required String userName,
  }) async {
    try {
      final emailTemplate = await _generateWelcomeEmailTemplate(
        userName: userName,
        userEmail: userEmail,
      );

      // EmailJS payload
      final payload = {
        'service_id': _serviceId,
        'template_id': _templateId,
        'user_id': _publicKey,
        'template_params': {
          'to_email': userEmail,
          'to_name': userName,
          'from_name': 'Gaiosophy Team',
          'subject': 'Welcome to Gaiosophy - Your Plant Wisdom Journey Begins! 🌿',
          'html_content': emailTemplate,
        }
      };

      final response = await http.post(
        Uri.parse(_emailJSUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        print('✅ Welcome email sent successfully to $userEmail');
        return true;
      } else {
        print('❌ Failed to send email. Status: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error sending welcome email: $e');
      return false;
    }
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
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Roboto+Slab:wght@400;500;600;700&family=Public+Sans:wght@400;500;600;700&display=swap');
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Public Sans', Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #FCF9F2;
        }
        
        .email-container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #ffffff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        
        .header {
            background: linear-gradient(135deg, #8B4513 0%, #8B6B47 100%);
            padding: 40px 30px;
            text-align: center;
            color: white;
        }
        
        .logo {
            font-family: 'Roboto Slab', serif;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 10px;
            letter-spacing: -0.5px;
        }
        
        .tagline {
            font-size: 16px;
            opacity: 0.9;
            font-weight: 400;
        }
        
        .content {
            padding: 40px 30px;
        }
        
        .greeting {
            font-family: 'Roboto Slab', serif;
            font-size: 24px;
            color: #8B4513;
            margin-bottom: 20px;
            font-weight: 600;
        }
        
        .message {
            font-size: 16px;
            line-height: 1.7;
            color: #5A5A5A;
            margin-bottom: 25px;
        }
        
        .features {
            background-color: #FCF9F2;
            border-radius: 12px;
            padding: 25px;
            margin: 30px 0;
        }
        
        .features-title {
            font-family: 'Roboto Slab', serif;
            font-size: 20px;
            color: #8B4513;
            margin-bottom: 20px;
            font-weight: 600;
        }
        
        .feature-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 15px;
            font-size: 15px;
            color: #5A5A5A;
        }
        
        .feature-icon {
            margin-right: 12px;
            font-size: 18px;
            margin-top: 2px;
        }
        
        .cta-button {
            display: inline-block;
            background: linear-gradient(135deg, #8B4513 0%, #8B6B47 100%);
            color: white;
            text-decoration: none;
            padding: 15px 30px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 16px;
            margin: 20px 0;
            transition: transform 0.2s ease;
        }
        
        .footer {
            background-color: #F5F0E8;
            padding: 30px;
            text-align: center;
            border-top: 1px solid #E5D5C0;
        }
        
        .footer-text {
            font-size: 14px;
            color: #8B6B47;
            margin-bottom: 10px;
        }
        
        .unsubscribe {
            font-size: 12px;
            color: #999;
        }
        
        .unsubscribe a {
            color: #8B6B47;
            text-decoration: none;
        }
        
        @media (max-width: 600px) {
            .email-container {
                margin: 0;
                border-radius: 0;
            }
            
            .header, .content, .footer {
                padding: 20px;
            }
            
            .logo {
                font-size: 28px;
            }
            
            .greeting {
                font-size: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="email-container">
        <div class="header">
            <div class="logo">🌿 Gaiosophy</div>
            <div class="tagline">Ancient Plant Wisdom for Modern Life</div>
        </div>
        
        <div class="content">
            <div class="greeting">Welcome, $userName! 🌱</div>
            
            <div class="message">
                We're thrilled to have you join the Gaiosophy community! Your journey into the mystical world of plant wisdom and ancient herbal knowledge begins now.
            </div>
            
            <div class="message">
                Gaiosophy is your gateway to discovering the profound connections between plants and human well-being, rooted in centuries of traditional wisdom and modern understanding.
            </div>
            
            <div class="features">
                <div class="features-title">What awaits you:</div>
                
                <div class="feature-item">
                    <span class="feature-icon">🌿</span>
                    <div><strong>Plant Profiles:</strong> Explore detailed information about medicinal and spiritual plants from around the world</div>
                </div>
                
                <div class="feature-item">
                    <span class="feature-icon">📚</span>
                    <div><strong>Ancient Wisdom:</strong> Learn traditional uses, folklore, and cultural significance of botanical allies</div>
                </div>
                
                <div class="feature-item">
                    <span class="feature-icon">🔮</span>
                    <div><strong>Mystical Properties:</strong> Discover the spiritual and energetic qualities attributed to different plants</div>
                </div>
                
                <div class="feature-item">
                    <span class="feature-icon">🌙</span>
                    <div><strong>Seasonal Guidance:</strong> Connect with plants according to natural cycles and lunar phases</div>
                </div>
                
                <div class="feature-item">
                    <span class="feature-icon">💫</span>
                    <div><strong>Personal Journey:</strong> Save favorites, track your learning, and build your own plant wisdom library</div>
                </div>
            </div>
            
            <div class="message">
                Your account has been created and you're ready to explore! Start by browsing our plant collection or diving into the seasonal wisdom that awaits.
            </div>
            
            <div style="text-align: center;">
                <a href="#" class="cta-button">Begin Your Journey 🌿</a>
            </div>
        </div>
        
        <div class="footer">
            <div class="footer-text">
                <strong>Gaiosophy Team</strong><br>
                Bridging ancient wisdom with modern understanding
            </div>
            <div class="unsubscribe">
                If you no longer wish to receive emails from us, you can <a href="#">unsubscribe here</a>
            </div>
        </div>
    </div>
</body>
</html>
''';
  }
}
