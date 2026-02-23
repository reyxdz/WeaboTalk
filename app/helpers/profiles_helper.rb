# frozen_string_literal: true

module ProfilesHelper
  # Get avatar image tag with fallback
  def profile_avatar(profile, size: "sm")
    size_classes = {
      "xs" => "w-8 h-8",
      "sm" => "w-12 h-12",
      "md" => "w-20 h-20",
      "lg" => "w-32 h-32"
    }

    classes = "#{size_classes[size]} rounded-full object-cover border-2 border-gray-200"

    if profile.avatar.attached?
      image_tag profile.avatar, alt: "#{profile.username}'s avatar", class: classes
    else
      tag.div(class: "#{classes} bg-gray-200 flex items-center justify-center") do
        tag.svg(class: "w-1/2 h-1/2 text-gray-400", fill: "currentColor", viewBox: "0 0 20 20") do
          tag.path("d": "M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z", "fill-rule": "evenodd", "clip-rule": "evenodd")
        end
      end
    end
  end

  # Get profile link with avatar and username
  def profile_link(profile)
    link_to profile_path(profile.username), class: "flex items-center gap-2 hover:opacity-80" do
      concat profile_avatar(profile, size: "sm")
      concat tag.span(profile.username, class: "font-semibold text-gray-900")
    end
  end

  # Format profile stats
  def profile_stats(profile)
    {
      followers: profile.followers_count,
      following: profile.following_count,
      posts: 0  # Future feature
    }
  end

  # Check if profile is complete (has username, bio, avatar)
  def profile_complete?(profile)
    profile.username.present? && profile.bio.present? && profile.avatar.attached?
  end

  # Get profile completion percentage
  def profile_completion_percentage(profile)
    completed_fields = 0
    completed_fields += 1 if profile.username.present?
    completed_fields += 1 if profile.bio.present?
    completed_fields += 1 if profile.avatar.attached?
    completed_fields += 1 if profile.banner.attached?

    ((completed_fields / 4.0) * 100).round
  end

  # Display formatted join date
  def profile_joined_date(profile)
    profile.created_at.strftime("%B %Y")
  end

  # Get user display name (from profile or email)
  def user_display_name(user)
    user.profile&.username || user.email.split("@").first
  end

  # Get user profile link
  def user_profile_link(user, classes = "")
    link_to user_display_name(user), profile_path(user.profile.username), class: classes
  end

  # Truncate bio for display
  def truncated_bio(profile, length: 100)
    if profile.bio.present?
      truncate(profile.bio, length: length)
    else
      tag.span("No bio yet", class: "text-gray-400 italic")
    end
  end
end
