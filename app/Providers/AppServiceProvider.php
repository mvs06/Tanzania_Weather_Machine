<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Vite;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // Use root-relative Vite asset paths so deployed containers do not emit localhost URLs.
        Vite::createAssetPathsUsing(static fn (string $path, ?bool $secure) => '/'.ltrim($path, '/'));
    }
}
